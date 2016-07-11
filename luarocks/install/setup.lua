#!/usr/bin/env lua

-- This script must run in the directory of this file.

local function loadvars()
  local site_config =  require('lua.luarocks.site_config')
  dofile('config.lua') -- load variables.MSVCRT as global

  return {
    LUA_RUNTIME = variables.MSVCRT, -- luacheck: ignore variables
    UNAME_M = site_config.LUAROCKS_UNAME_M,
    LUAROCKS_PREFIX = site_config.LUAROCKS_PREFIX
  }
end

local function scanfiles()
  local rv = {
    'lua/luarocks/site_config.lua',
    'config.lua',
  }

  local h = io.popen('dir /B *.bat')
  for line in h:lines() do
    rv[#rv+1] = line
  end

  return rv
end

local function read(file)
  local f = io.open(file, 'rb')
  if not f then return nil end
  local d = f:read('*a')
  f:close()
  return d
end

local function write(file, content)
  local f = io.open(file, 'wb')
  if not f then return nil end
  f:write(content)
  f:close()
end

local function relocate(files, oldroot, newroot)
  local oldroot2, newroot2 = oldroot:gsub('/', '\\'), newroot:gsub('/', '\\')
  for _, f in ipairs(files) do
    local text = read(f)
    if text then
      local relocated = text:gsub(oldroot, newroot):gsub(oldroot2, newroot2)
      if relocated ~= text then
        print('Relocating:', f)
        write(f, relocated)
      end
    end
  end
end


local function exists(filename)
  local f = io.open(filename, "r")
  if f~=nil then
    io.close(f) return true
  else
    return false
  end
end

-- get a string value from windows registry.
local function get_registry(paths)
  for _, path in ipairs(paths) do
    local key, value = path:match('^(.+):([^:]+)$')
    local h = io.popen('reg query "'..key..'" /v '..value..' 2>NUL')
    local output = h:read("*a")
    h:close()
    local v = (output:match("REG_SZ%s+([^\n]+)"))
    if v ~= nil then return v end
  end
  return nil
end

-- returns the batch command and arg to setup msvc compiler path.
-- or return 2 empty string (eg. '', '') if not found
local function get_msvc_env_setup_cmd()
  local arch = '@LUA_CPUARCH@' -- 'amd64' or 'x86'

  -- 1. try visual studio command line tools
  local vcdir = get_registry({
    [[HKLM\Software\Wow6432Node\Microsoft\VisualStudio\@VC_VERSION@\Setup\VC:ProductDir]],
    [[HKLM\Software\Microsoft\VisualStudio\@VC_VERSION@\Setup\VC:ProductDir]],
    [[HKLM\Software\Wow6432Node\Microsoft\VCExpress\@VC_VERSION@\Setup\VS:ProductDir]],
    [[HKLM\Software\Microsoft\VCExpress\@VC_VERSION@\Setup\VS:ProductDir]],
  })
  if vcdir then
    -- 1.1. try vcvarsall.bat
    local vcvarsall = vcdir .. 'vcvarsall.bat'
    if exists(vcvarsall) then
      return vcvarsall, arch
    end

    -- 1.2. try vcvars32.bat / vcvars64.bat
    local relative_path = arch =='amd64' and 'bin\\amd64\\vcvars64.bat' or 'bin\\vcvars32.bat'
    local full_path = vcdir .. relative_path
    if exists(full_path) then
      return full_path, ''
    end
  end

  -- 2. try for Windows SDKs command line tools.
  local wsdkdir = get_registry({
    [[HKLM\Software\Microsoft\Microsoft SDKs\Windows\v@WSDK_VERSION@:InstallationFolder]],
    [[HKLM\Software\Microsoft\Microsoft SDKs\Windows\v@WSDK_VERSION@:InstallationFolder]],
  })
  if wsdkdir then
    local setenv = wsdkdir..'Bin\\SetEnv.cmd'
    if exists(setenv) then
      return setenv, arch == 'amd64' and 'x64' or 'x86'
    end
  end

  -- finally, we can't detect more, just don't setup the msvc compiler in luarocks.bat.
  return '', ''
end

local function update_vcvars(file, vccmd, vcarg)
  local content = read(file)
  if not content then return end
  local modified = content:gsub('(SET VCBAT=)[^\r\n]*', '%1'..vccmd):gsub('(SET VCARG=)[^\r\n]*', '%1'..vcarg)
  if modified ~= content then
    write(file, modified)
  end
end

local function main()
  if not arg[1] then
    print('Run please setup.cmd')
    os.exit(1)
  end
  local root = arg[1]
  print(('Setup luarocks in (%s)'):format(root))

  local vars = loadvars(root)

  relocate(scanfiles(root), vars.LUAROCKS_PREFIX, root:gsub('\\', '/'))

  update_vcvars('luarocks.bat', get_msvc_env_setup_cmd(vars))
end

main()

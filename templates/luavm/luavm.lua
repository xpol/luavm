#!/usr/bin/env lua
-- luavm use 5.1.5
-- luavm use luajit-2.1.0
-- luavm versions



local function run(luafile)
  local chunk = loadfile(luafile)
  local g = {}
  setfenv(chunk, g)
  return g, chunk()
end


-- This script must run in the directory of this file.

local function loadvars(luadir)
  local _, site_config = run(luadir..'/lua/luarocks/site_config.lua')
  local g, _ = run(luadir..'/config.lua') -- load variables.MSVCRT as global

  local major, minor = g.variables.MSVCRT:match('VCR%u*(%d+)(%d)$') -- MSVCR<x><y> or VCRUNTIME<x><y>

  local VCVERSION = major..'.'..minor
  local wsdkvers = {
    ['9.0'] = '6.1',
    ['10.0'] = '7.1'
  }

  return {
    VCVER = VCVERSION,
    WSDKVER = wsdkvers[VCVERSION],
    CPUARCH = site_config.LUAROCKS_UNAME_M:find('64') ~= nil and 'amd64' or 'x86',
    PREFIX = site_config.LUAROCKS_PREFIX
  }
end

local function scanfiles(bindir)
  local rv = {
    bindir..'/lua/luarocks/site_config.lua',
    bindir..'/config.lua',
  }

  local h = io.popen(('dir /B "%s\\*.bat"'):format(bindir:gsub('/', '\\')))
  for line in h:lines() do
    rv[#rv+1] = bindir..'/'..line
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
  local oldroot2 = oldroot:gsub('/', '\\')
  newroot = newroot:gsub('\\', '/')
  for _, f in ipairs(files) do
    local text = read(f)
    if text then
      local relocated = text:gsub(oldroot, newroot):gsub(oldroot2, newroot)
      if relocated ~= text then
        -- print('Relocating:', f)
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
  if type(paths) == 'string' then paths = {paths} end
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

local function set_environment(variable, value)
  local z = os.execute(('setx "%s" "%s" >NUL'):format(variable, value))
  return z == 0 or z == true
end

local function portable_slash(path)
  return path:gsub('\\', '/')
end

-- returns the batch command and arg to setup msvc compiler path.
-- or return 2 empty string (eg. '', '') if not found
local function get_msvc_env_setup_cmd(vcver, wsdkver, needs64)
  -- 1. try visual studio command line tools
  local vcdir = get_registry({
    [[HKLM\Software\Wow6432Node\Microsoft\VisualStudio\]]..vcver..[[\Setup\VC:ProductDir]],
    [[HKLM\Software\Microsoft\VisualStudio\]]..vcver..[[\Setup\VC:ProductDir]],
    [[HKLM\Software\Wow6432Node\Microsoft\VCExpress\]]..vcver..[[\Setup\VS:ProductDir]],
    [[HKLM\Software\Microsoft\VCExpress\]]..vcver..[[\Setup\VS:ProductDir]],
  })
  if vcdir then
    -- 1.1. try vcvarsall.bat
    local vcvarsall = vcdir .. 'vcvarsall.bat'
    if exists(vcvarsall) then
      return portable_slash(vcvarsall), needs64 and 'amd64' or 'x86'
    end

    -- 1.2. try vcvars32.bat / vcvars64.bat
    local relative_path = needs64 and 'bin/amd64/vcvars64.bat' or 'bin/vcvars32.bat'
    local full_path = vcdir .. relative_path
    if exists(full_path) then
      return portable_slash(full_path), ''
    end
  end

  -- 2. try for Windows SDKs command line tools.
  if wsdkver then
    local wsdkdir = get_registry({
      [[HKLM\Software\Microsoft\Microsoft SDKs\Windows\v]]..wsdkver..[[:InstallationFolder]],
      [[HKLM\Software\Microsoft\Microsoft SDKs\Windows\v]]..wsdkver..[[:InstallationFolder]],
    })
    if wsdkdir then
      local setenv = wsdkdir..'Bin/SetEnv.cmd'
      if exists(setenv) then
        return portable_slash(setenv), needs64 and 'x64' or 'x86'
      end
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

local function path_insert(pathstring, newpath, removefn)
  local paths = {}
  local replaced = false
  for p in pathstring:gmatch('([^;]+)') do
    if not replaced and removefn(p) then
      paths[#paths+1] = newpath
      replaced = true
    else
      paths[#paths+1] = p
    end
  end
  if not replaced then
    table.insert(paths, 1, newpath)
  end
  return table.concat(paths, ';')
end

local function allowed_versions(home)
  local h = io.popen(([[dir /B "%sversions\*"]]):format(home))
  local versions = {}
  for v in h:lines() do
    versions[v] = true
    versions[#versions+1] = v
  end
  return versions
end

local function list(home)
  io.stdout:write('  ', table.concat(allowed_versions(home), '\n  '), '\n')
  os.exit(0)
end

local function use(home, version)
  local versions = allowed_versions(home)
  if not versions[version] then
    io.stderr:write(('invliad version: "%s"\n'):format(version))
    io.stderr:write(('installed versions: \n  "%s"\n'):format(table.concat(versions, '\n  ')))
    os.exit(1)
  end

  local base = (home..[[versions\]]):lower()
  local bindir = home..[[versions\]]..version
  local function is_old_bindir(dir)
    return dir:sub(1,#base):lower() == base
  end

  -- print[[1. update path in registry]]
  local path = path_insert(get_registry([[HKCU\Environment:Path]]), bindir, is_old_bindir)
  set_environment('Path', path)

  -- print[[2. create batch file to update path in current session]]
  path = path_insert(os.getenv('Path'), bindir, is_old_bindir)
  local tempfile = io.open(os.getenv('LUAVMTMPFILE'), 'w')
  tempfile:write('set PATH='..path)

  -- print[[3. update install directory for lua]]
  local vars = loadvars(bindir)
  relocate(scanfiles(bindir), vars.PREFIX, bindir:gsub('\\', '/'))

  -- print[[4. update visual c++ compiler command for luarocks.]]
  local vccmd, vcarg = get_msvc_env_setup_cmd(vars.VCVER, vars.WSDKVER, vars.CPUARCH:find('64') ~= nil)
  update_vcvars(bindir..[[\luarocks.bat]], vccmd, vcarg)
end

local function main()
  local home = arg[0]:match([[^([A-Z]:.+\)luavm\luavm.lua$]])
  if not home then
    error('Need to run luavm.lua with full path.')
    os.exit(1)
  end

  if arg[1] == 'use' then
    use(home, arg[2])
  elseif arg[1] == 'list' then
    list(home)
  end
end

main()

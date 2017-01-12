#!/usr/bin/env lua

local VERSION = '@LUAVM_VERSION@'

local function run(luafile)
  local chunk = loadfile(luafile)
  local g = {}
  setfenv(chunk, g)
  return g, chunk()
end

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

local function scan_path_related_files(bindir)
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

local function relocate_bin_scripts(files, oldroot, newroot)
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


-- Get environment variable from windows registry or current session
--   - source: 'machine' or 'user' or 'session'
--   - varname: the name of environment variable.
local function getenv(source, varname)
  if source == 'session' then return os.getenv(varname) end

  local sources = {
    machine = [[HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment]],
    user = [[HKCU\Environment]]
  }
  local key = sources[source]
  if not key then error('Unknown environment source: '..source) end

  local h = io.popen('reg query "'..key..'" /v '..varname..' 2>NUL')
  local output = h:read("*a")
  h:close()
  return (output:match("REG_[^%s]+%s+([^\n]+)"))
end

local function execf(fmt,...)
  local cmd = fmt:format(...)
  --print(cmd)
  local r = os.execute(cmd)
  assert(r == 0 or r == true, 'error while executing: ' .. cmd)
end

-- Set environment variable into windows registry or current session
--   - source: 'machine' or 'user' or 'session'
--   - varname: the name of environment variable.
--   - value: the value of environment variable.
local function setenv(source, varname, value)
  if source == 'session' then
    local tempfile = io.open(os.getenv('SESSION_UPDATE_BATCH'), 'w')
    tempfile:write(('set %s=%s'):format(varname, value))
    tempfile:close()
  end

  if source == 'user' then
    execf('setx "%s" "%s" >NUL', varname, value)
  end

  if source == 'machine' then
    execf('setx /M "%s" "%s" >NUL', varname, value)
  end
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
      local setenvcmd = wsdkdir..'Bin/SetEnv.cmd'
      if exists(setenvcmd) then
        return portable_slash(setenvcmd), needs64 and 'x64' or 'x86'
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


local function allowed_versions(home)
  local h = io.popen(([[dir /B "%s\versions\*"]]):format(home))
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

local function filter_path(s, new, fn)
  local paths = {new}
  if type(fn) == 'string' then
    local regx = fn
    fn = function(p) return (p:find(regx)) end
  end
  for p in s:gmatch('([^;]+)') do
    if not fn(p) then
      paths[#paths+1] = p
    end
  end
  return table.concat(paths, ';')
end

local function update_path(sources, newpath, oldregx)
  for source in sources:gmatch('([^:]+)') do
    setenv(source, 'Path', filter_path(getenv(source, 'Path'), newpath, oldregx))
  end
end

local function use(home, version)
  local versions = allowed_versions(home)
  if not versions[version] then
    io.stderr:write(('invalid version: "%s"\n'):format(version))
    io.stderr:write(('installed versions: \n  "%s"\n'):format(table.concat(versions, '\n  ')))
    os.exit(1)
  end

  local bindir = home..[[\versions\]]..version

  -- print[[1. update path in registry and current session]]
  update_path('user:session', bindir, '\\LuaVM\\versions\\[^\\]+$')

  -- print[[3. update install directory for lua bin scripts]]
  local vars = loadvars(bindir)
  relocate_bin_scripts(scan_path_related_files(bindir), vars.PREFIX, bindir:gsub('\\', '/'))

  -- print[[4. update visual c++ compiler command for luarocks.]]
  local vccmd, vcarg = get_msvc_env_setup_cmd(vars.VCVER, vars.WSDKVER, vars.CPUARCH:find('64') ~= nil)
  update_vcvars(bindir..[[\luarocks.bat]], vccmd, vcarg)
end

local function migrate(mode, path)
  if mode == 'install' then
    update_path('user:session', path, '\\LuaVM$')
  elseif mode == 'remove' then
    update_path('user:session', nil, '\\LuaVM$')
    update_path('user:session', nil, '\\LuaVM\\versions\\[^\\]+$')
  else
    print('Usage: luavm migrate install')
    print('   or: luavm migrate remove')
    os.exit(1)
  end
end

local function usage(code)
  print [=[usage: luavm <command> [<args>]

The commands are:
   use        Use specified version of Lua.
   list       List all installed versions of Lua.
   migrate    Install or remove luavm in system PATH.
]=]
  os.exit(code or 0)
end

local function main()
  local home = arg[0]:match([[^([A-Z]:.+\LuaVM)\luavm.lua$]])

  if not home then
    error('Need to run luavm.lua with full path.')
    os.exit(1)
  end

  if not arg[1] then usage() end

  local commands = {
    migrate = function() migrate(arg[2], home) end,
    list = function() list(home) end,
    use = function() use(home, arg[2]) end,
    version = function() print(VERSION) end,
  }
  if not commands[arg[1]] then
    error(('Unknown command %s.'):format(arg[1]))
    os.exit(1)
  end

  commands[arg[1]]()
end

main()

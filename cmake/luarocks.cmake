include(cmake/msvc.cmake) # load msvc variables

function(config_luarocks lua_version lua_interpreter lua_libname)
  set(LUA_INCDIR "HOME/include") # Directory for the Lua headers"
  set(LUA_LIBDIR "HOME") # Directory for Lua library
  set(LUA_BINDIR "HOME") # Directory for Lua interpreter executable


  set(_UNAME_M_FOR_BYTES_8 "x86_64")
  set(_UNAME_M_FOR_BYTES_4 "x86")

  # Configs
  set(LUAROCKS_PREFIX "HOME")
  set(LUAROCKS_SYSCONFDIR "HOME")
  set(LUAROCKS_ROCKS_TREE "HOME")
  set(LUAROCKS_ROCKS_SUBDIR "rocks")
  set(LUAROCKS_UNAME_S "WindowsNT")
  set(LUAROCKS_UNAME_M "${_UNAME_M_FOR_BYTES_${CMAKE_SIZEOF_VOID_P}}")
  set(LUAROCKS_DOWNLOADER "wget")
  set(LUAROCKS_MD5CHECKER "md5sum")
  set(LUAROCKS_BINDIR "HOME")
  set(LUAROCKS_CMODDIR "HOME/cmod")
  set(LUAROCKS_LUADIR "HOME/lua")
  set(LUAROCKS_EXTERNAL_DEPS_DIR "HOME/../../externals")

  set(LUA_INTERPRETER ${lua_interpreter})
  set(LUA_LIBNAME ${lua_libname})

  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${lua_version}")

  configure_file("${PROJECT_SOURCE_DIR}/luavm/templates/site_config.lua" "${PREFIX}/lua/luarocks/site_config.lua")
  configure_file("${PROJECT_SOURCE_DIR}/luavm/templates/config.lua" "${PREFIX}/config.lua")
  configure_file("${PROJECT_SOURCE_DIR}/luavm/templates/luarocks.bat" "${PREFIX}/luarocks.bat" NEWLINE_STYLE WIN32)
endfunction()

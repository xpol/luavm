
function(config_luarocks lua_version lua_interpreter lua_libname)
  set(LUA_INTERPRETER ${lua_interpreter})
  set(LUA_LIBNAME ${lua_libname})

  configure_file("${LUAINSTALLER_SOURCE_DIR}/luarocks/install/site_config.lua" "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/site_config.lua")
  configure_file("${LUAINSTALLER_SOURCE_DIR}/luarocks/install/config.lua" "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/config.lua")
  configure_file("${LUAINSTALLER_SOURCE_DIR}/luarocks/install/luarocks.bat" "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/luarocks.bat" NEWLINE_STYLE WIN32)
  configure_file("${LUAINSTALLER_SOURCE_DIR}/luarocks/install/setup.cmd" "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/setup.cmd" NEWLINE_STYLE WIN32)
  configure_file("${LUAINSTALLER_SOURCE_DIR}/luarocks/install/setup.lua" "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/setup")
endfunction()

function(install_luarocks lua_version)
  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${lua_version}")
  install(DIRECTORY DESTINATION "${PREFIX}/cmod")
  install(DIRECTORY DESTINATION "${PREFIX}/rocks")
  install(DIRECTORY "${LUAINSTALLER_SOURCE_DIR}/luarocks/win32/tools" DESTINATION "${PREFIX}")
  install(DIRECTORY "${LUAINSTALLER_SOURCE_DIR}/luarocks/src/luarocks" DESTINATION "${PREFIX}/lua")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/site_config.lua" DESTINATION "${PREFIX}/lua/luarocks")
  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/config.lua" DESTINATION "${PREFIX}")
  install(FILES
    "${LUAINSTALLER_SOURCE_DIR}/luarocks/src/bin/luarocks"
    "${LUAINSTALLER_SOURCE_DIR}/luarocks/src/bin/luarocks-admin"
    "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/luarocks.bat"
    "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/setup.cmd"
    "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/setup"
  DESTINATION "${PREFIX}")

  install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/${lua_version}/luarocks.bat" DESTINATION "${PREFIX}" RENAME luarocks-admin.bat)
endfunction()

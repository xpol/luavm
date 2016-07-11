cmake_minimum_required(VERSION 2.8)
project(luarocks)

if(NOT WIN32)
  message(FATAL_ERROR "Only Windows are supported." )
endif()


configure_file("install/site_config.lua" "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/site_config.lua")
configure_file("install/config.lua" "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua")
configure_file("install/luarocks.bat" "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks.bat" NEWLINE_STYLE WIN32)
configure_file("install/setup.cmd" "${CMAKE_CURRENT_BINARY_DIR}/src/setup.cmd" NEWLINE_STYLE WIN32)
configure_file("install/setup.lua" "${CMAKE_CURRENT_BINARY_DIR}/src/setup")

install(DIRECTORY DESTINATION ${LUAROCKS_LUADIR})
install(DIRECTORY DESTINATION ${LUAROCKS_CMODDIR})
install(DIRECTORY DESTINATION ${LUAROCKS_ROCKS_TREE}/${LUAROCKS_ROCKS_SUBDIR})
install(DIRECTORY win32/tools DESTINATION "${LUAROCKS_BINDIR}")
install(DIRECTORY "src/luarocks" DESTINATION "${LUAROCKS_LUADIR}")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/site_config.lua" DESTINATION "${LUAROCKS_LUADIR}/luarocks")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua" DESTINATION "${LUAROCKS_SYSCONFDIR}")
install(FILES
  "src/bin/luarocks"
  "src/bin/luarocks-admin"
  "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua"
  "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks.bat"
  "${CMAKE_CURRENT_BINARY_DIR}/src/setup.cmd"
  "${CMAKE_CURRENT_BINARY_DIR}/src/setup"
  DESTINATION "${LUAROCKS_BINDIR}")

install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks.bat" DESTINATION "${LUAROCKS_BINDIR}" RENAME luarocks-admin.bat)
install(CODE "execute_process(COMMAND ${LUAROCKS_BINDIR}/setup.cmd)")

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

install(DIRECTORY DESTINATION "${CMAKE_INSTALL_PREFIX}/cmod")
install(DIRECTORY DESTINATION "${CMAKE_INSTALL_PREFIX}/rocks")
install(DIRECTORY win32/tools DESTINATION "${CMAKE_INSTALL_PREFIX}")
install(DIRECTORY "src/luarocks" DESTINATION "${CMAKE_INSTALL_PREFIX}/lua")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/site_config.lua" DESTINATION "${CMAKE_INSTALL_PREFIX}/lua/luarocks")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua" DESTINATION "${CMAKE_INSTALL_PREFIX}")
install(FILES
  "src/bin/luarocks"
  "src/bin/luarocks-admin"
  "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks.bat"
  "${CMAKE_CURRENT_BINARY_DIR}/src/setup.cmd"
  "${CMAKE_CURRENT_BINARY_DIR}/src/setup"
  DESTINATION "${CMAKE_INSTALL_PREFIX}")

install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks.bat" DESTINATION "${CMAKE_INSTALL_PREFIX}" RENAME luarocks-admin.bat)

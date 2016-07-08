cmake_minimum_required(VERSION 2.8)
project(luarocks)

if(NOT WIN32)
  message(FATAL_ERROR "Only Windows are supported." )
endif()



install(DIRECTORY win32/tools DESTINATION "${LUAROCKS_BINDIR}")
install(DIRECTORY "src/luarocks" DESTINATION "${LUAROCKS_LUADIR}")

configure_file("cmake/site_config.lua.in" "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/site_config.lua")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/site_config.lua" DESTINATION "${LUAROCKS_LUADIR}/luarocks")

configure_file("cmake/config.lua.in" "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/src/luarocks/config.lua" DESTINATION "${LUAROCKS_SYSCONFDIR}")

configure_file("cmake/cmd.in" "${CMAKE_CURRENT_BINARY_DIR}/bin/cmd.bat")
install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/bin/cmd.bat" DESTINATION "${LUAROCKS_BINDIR}" RENAME luarocks.bat)
install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/bin/cmd.bat" DESTINATION "${LUAROCKS_BINDIR}" RENAME luarocks-admin.bat)
install(PROGRAMS "src/bin/luarocks" DESTINATION "${LUAROCKS_BINDIR}")
install(PROGRAMS "src/bin/luarocks-admin" DESTINATION "${LUAROCKS_BINDIR}")

cmake_minimum_required(VERSION 2.8)
project(luajit-2.0)

#add_custom_command(OUTPUT luajit.exe lua51.dll lua51.lib
#                   COMMAND cmd /C ${CURRENT_SOURCE_DIR}\\src\\msvcbuild.bat
#                   WORKING_DIRECTORY src)

#add_executable(luajit IMPORTED luajit.exe)
include(ExternalProject)

ExternalProject_Add(luajit-2.0
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/src/msvcbuild.bat"
  BUILD_BYPRODUCTS luajit.exe lua51.dll lua51.lib
  INSTALL_COMMAND ""
)

install(FILES src/luajit.exe src/lua51.dll DESTINATION "bin")
install(DIRECTORY src/jit DESTINATION "bin/lua")
install(FILES src/lua51.lib DESTINATION "lib")
install(FILES src/lua.h src/lua.hpp src/luaconf.h src/lauxlib.h src/lualib.h src/luajit.h DESTINATION "include")
install(DIRECTORY doc DESTINATION "${CMAKE_INSTALL_PREFIX}")

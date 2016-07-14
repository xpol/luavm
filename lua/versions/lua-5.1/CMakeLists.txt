cmake_minimum_required(VERSION 2.8)
project(lua-5.1)

set(SRC_LIB
  src/lapi.c src/lcode.c src/ldebug.c src/ldo.c src/ldump.c src/lfunc.c src/lgc.c src/llex.c src/lmem.c
  src/lobject.c src/lopcodes.c src/lparser.c src/lstate.c src/lstring.c src/ltable.c src/ltm.c
  src/lundump.c src/lvm.c src/lzio.c

  src/lauxlib.c src/lbaselib.c src/ldblib.c src/liolib.c
  src/lmathlib.c src/loslib.c src/ltablib.c src/lstrlib.c src/loadlib.c src/linit.c
  src/luaconf.h)

add_definitions(-D_CRT_SECURE_NO_WARNINGS)

# Shared library and executables
add_library(lua51 SHARED ${SRC_LIB})
set_target_properties (lua51 PROPERTIES COMPILE_DEFINITIONS LUA_BUILD_AS_DLL)
add_executable(lua src/lua.c)
target_link_libraries(lua lua51)
add_executable(luac src/luac.c src/print.c ${SRC_LIB})

set(LUA_INTERPRETER lua.exe CACHE INTERNAL "The name of Lua interpreter executable")
set(LUA_LIBNAME lua51.lib CACHE INTERNAL "The name of Lua library")
set(LUA_VERSION Lua-5.1.5 CACHE INTERNAL "The version of Lua")

# Install files
install(TARGETS lua luac lua51 RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}" LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}" ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}")
install(FILES src/lua.h etc/lua.hpp src/luaconf.h src/lualib.h src/lauxlib.h DESTINATION "${CMAKE_INSTALL_PREFIX}/include")
install(DIRECTORY doc DESTINATION "${CMAKE_INSTALL_PREFIX}")

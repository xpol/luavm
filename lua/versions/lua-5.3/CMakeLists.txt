cmake_minimum_required(VERSION 2.8)
project(lua-5.3)

SET(SRC_LIB
  src/lapi.c src/lcode.c src/lctype.c src/ldebug.c src/ldo.c src/ldump.c
  src/lfunc.c src/lgc.c src/llex.c src/lmem.c src/lobject.c src/lopcodes.c src/lparser.c
  src/lstate.c src/lstring.c src/ltable.c src/ltm.c src/lundump.c src/lvm.c src/lzio.c

  src/lauxlib.c src/lbaselib.c src/lbitlib.c src/lcorolib.c src/ldblib.c
  src/liolib.c src/lmathlib.c src/loadlib.c src/loslib.c src/lstrlib.c src/ltablib.c
  src/linit.c src/lutf8lib.c)

add_definitions(-D_CRT_SECURE_NO_WARNINGS)
# Shared library and executables
add_library(lua5.3 SHARED ${SRC_LIB})
set_target_properties (lua5.3 PROPERTIES COMPILE_DEFINITIONS LUA_BUILD_AS_DLL)

add_executable(lua src/lua.c)
target_link_libraries(lua lua5.3)

add_executable(luac src/luac.c ${SRC_LIB})

# Install files
install(TARGETS lua luac lua5.3
  RUNTIME DESTINATION "bin"
  LIBRARY DESTINATION "bin"
  ARCHIVE DESTINATION "lib")

install(FILES src/lua.h src/lua.hpp src/luaconf.h src/lualib.h src/lauxlib.h DESTINATION "include")

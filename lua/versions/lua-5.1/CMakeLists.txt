set(SRC_LIB
  src/lapi.c src/lcode.c src/ldebug.c src/ldo.c src/ldump.c src/lfunc.c src/lgc.c src/llex.c src/lmem.c
  src/lobject.c src/lopcodes.c src/lparser.c src/lstate.c src/lstring.c src/ltable.c src/ltm.c
  src/lundump.c src/lvm.c src/lzio.c

  src/lauxlib.c src/lbaselib.c src/ldblib.c src/liolib.c
  src/lmathlib.c src/loslib.c src/ltablib.c src/lstrlib.c src/loadlib.c src/linit.c
  src/luaconf.h)

add_lua(
  VERSION 5.1 ABI 51
  LIBRARY_FILES ${SRC_LIB}
  LUAC_FILES src/luac.c src/print.c ${SRC_LIB}
  HEADERS src/lua.h etc/lua.hpp src/luaconf.h src/lualib.h src/lauxlib.h)

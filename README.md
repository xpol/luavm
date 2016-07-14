# luainstaller

Lua installer for Windows.

## Prerequiets

1. Install Visual Studio, Visual Studio 2015 or Visual Studio 2013 is recommended.
2. Insstall CMake.

## Install

```Batch
cmake -H. -Bbuild -G"Visual Studio 14 2015" -DWITH_LUA=lua-5.1 -DCMAKE_INSTALL_PREFIX=PREFIX
cmake --build build --config Release --target install
iscc LuaInstaller.iss /O. /FLuaInstaller.exe
```

Where cmake generator can be one of:

- Visual Studio 10 2010
- Visual Studio 10 2010 Win64
- Visual Studio 11 2012
- Visual Studio 11 2012 Win64
- Visual Studio 12 2013
- Visual Studio 12 2013 Win64
- Visual Studio 14 2015
- Visual Studio 14 2015 Win64
- Visual Studio 9 2008
- Visual Studio 9 2008 Win64

`WITH_LUA` can be one of:

- lua-5.1
- lua-5.2
- lua-5.3
- luajit-2.0
- luajit-2.1

`CMAKE_INSTALL_PREFIX` is the path to install Lua and LuaRocks.

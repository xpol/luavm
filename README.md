# luavm

Lua Version Manager for Windows.

* LuaVM is a simple installer contains prebuilt [Lua][] and [LuaJIT][] binaries with configured [LuaRocks][].
* LuaVM is a command line tool make it easy switch between Lua versions.

## Install

1. Download installer form [GitHub](https://github.com/xpol/luavm/releases) or [Bintray](https://bintray.com/xpol/luavm/luavm-development#files).
2. Double click to install or form command line `LuaVM-x.y.z-vs[2015|2013]-x[64|86].exe /verysilent /dir=path\to\install`.


Examples appveyor.yml config:

```yml
install:
  - appveyor DownloadFile https://dl.bintray.com/xpol/luavm/LuaVM-0.4.0-vs2015-x64.exe -FileName LuaVM-vs2015-x64.exe
  - LuaVM-vs2015-x64.exe /verysilent /dir=C:\luavm
```

## Usage

List Lua versions:

> luavm list


Use specified Lua version:

> luavm use <version>

Eg.

> luavm use 5.1

Then `lua.exe` for Lua 5.1 is in current and future cmd session's PATH.
For LuaJIT versions there is also `luajit.exe` in PATH.


## Development

### Prerequiets

1. Install [Visual Studio](https://www.visualstudio.com/downloads/download-visual-studio-vs), Visual Studio 2015 or Visual Studio 2013 is recommended.
2. Insstall [CMake](https://cmake.org/).
3. Install [InnoSetup](http://www.jrsoftware.org/isinfo.php) and make sure `iscc` is in your PATH.

### Build

To build and create installer in the project root directory:

```Batch
cmake -H. -Bbuild -G"Visual Studio 14 2015 Win64"
cmake --build build --config Release --target installer
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


[Lua]: https://www.lua.org/
[LuaJIT]: http://luajit.org/
[LuaRocks]: https://luarocks.org/

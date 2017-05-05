# luavm

Lua Version Manager for Windows.

* LuaVM is a simple installer contains prebuilt [Lua][] and [LuaJIT][] binaries with [LuaRocks][].
* LuaVM is a command line tool make it easy switch between Lua versions.

## Install

1. Download installer from [GitHub](https://github.com/xpol/luavm/releases) or [Bintray](https://bintray.com/xpol/luavm/luavm-development#files).
2. Double click to install or form command line `LuaVM-x.y.z-vs[2015|2013]-x[64|86].exe /verysilent`.


Examples appveyor.yml config:

```yml
install:
  - appveyor DownloadFile https://dl.bintray.com/xpol/luavm/LuaVM-0.5.0-vs2015-x64.exe -FileName LuaVM-vs2015-x64.exe
  - LuaVM-vs2015-x64.exe /verysilent
  - set PATH=%LocalAppData%\LuaVM;%PATH%
  - luavm use 5.3
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

### Prerequisites

1. Install [Visual Studio](https://www.visualstudio.com/downloads/download-visual-studio-vs), Visual Studio 2017 or Visual Studio 2015 is recommended.
2. Install [CMake](https://cmake.org/).
3. Install [InnoSetup](http://www.jrsoftware.org/isinfo.php) and make sure `iscc` is in your PATH.

The follow items are required by building OpenSSL:

1. Install [NASM](http://www.nasm.us/) and make sure `nasm` is in your PATH.
2. Install [Python 2.7/3.x](http://python.org/) and make sure `python` is in your PATH.
3. Install [7zip](http://www.7-zip.org/).
4. Install [Perl](http://www.activestate.com/activeperl/downloads).

### Build

To build and create installer in the project root directory:

```Batch
cmake -H. -Bbuild -G"Visual Studio 14 2015 Win64"
cmake --build build --config Release --target installer
```

Where cmake generator may be one of:

- Visual Studio 12 2013
- Visual Studio 12 2013 Win64
- Visual Studio 14 2015
- Visual Studio 14 2015 Win64
- Visual Studio 15 2017
- Visual Studio 15 2017 Win64


[Lua]: https://www.lua.org/
[LuaJIT]: http://luajit.org/
[LuaRocks]: https://luarocks.org/

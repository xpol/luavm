# luavm

Lua Version Manager for Windows.

## Prerequiets

1. Install [Visual Studio](https://www.visualstudio.com/downloads/download-visual-studio-vs), Visual Studio 2015 or Visual Studio 2013 is recommended.
2. Insstall [CMake](https://cmake.org/).
3. Install [InnoSetup](http://www.jrsoftware.org/isinfo.php) and make sure `iscc` is in your PATH.

## Install

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

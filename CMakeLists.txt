cmake_minimum_required(VERSION 2.6 FATAL_ERROR)
project(luainstaller)

# We want release compilation by default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

if (NOT DEFINED WITH_LUA)
  set(WITH_LUA luajit-2.1 CACHE STRING "Wihci version of Lua to be used? options are: lua-5.1 lua-5.2 lua-5.3 luajit-2.0 or luajit-2.1" FORCE)
endif()
option(WITH_LUAROCKS "Install Luarocks" ON)


set(LUA_INCDIR "${CMAKE_INSTALL_PREFIX}/include" CACHE INTERNAL "Directory for the Lua headers")
set(LUA_LIBDIR "${CMAKE_INSTALL_PREFIX}" CACHE INTERNAL "Directory for Lua library")
set(LUA_BINDIR "${CMAKE_INSTALL_PREFIX}" CACHE INTERNAL "Directory for Lua interpreter executable")


set(_UNAME_M_FOR_BYTES_8 "x86_64")
set(_UNAME_M_FOR_BYTES_4 "x86")

# Configs
set(LUAROCKS_PREFIX "${CMAKE_INSTALL_PREFIX}")
set(LUAROCKS_SYSCONFDIR "${CMAKE_INSTALL_PREFIX}")
set(LUAROCKS_ROCKS_TREE "${CMAKE_INSTALL_PREFIX}")
set(LUAROCKS_ROCKS_SUBDIR "rocks")
set(LUAROCKS_UNAME_S "WindowsNT")
set(LUAROCKS_UNAME_M "${_UNAME_M_FOR_BYTES_${CMAKE_SIZEOF_VOID_P}}")
set(LUAROCKS_DOWNLOADER "wget")
set(LUAROCKS_MD5CHECKER "md5sum")
set(LUAROCKS_BINDIR ${LUA_BINDIR})
set(LUAROCKS_CMODDIR "${CMAKE_INSTALL_PREFIX}/cmod")
set(LUAROCKS_LUADIR "${CMAKE_INSTALL_PREFIX}/lua")


message("${CMAKE_CXX_COMPILER_VERSION}")

set(_MSVCRT_1200 "MSVCRT")      # Visual Studio 6.0
set(_MSVCRT_1300 "MSVCR70")     # Visual Studio 2002
set(_MSVCRT_1310 "MSVCR71")     # Visual Studio 2003
set(_MSVCRT_1400 "MSVCR80")     # Visual Studio 2005
set(_MSVCRT_1500 "MSVCR90")     # Visual Studio 2008
set(_MSVCRT_1600 "MSVCR100")    # Visual Studio 2010
set(_MSVCRT_1700 "MSVCR110")    # Visual Studio 2012
set(_MSVCRT_1800 "MSVCR120")    # Visual Studio 2013
set(_MSVCRT_1900 "VCRUNTIME140")# Visual Studio 2015

set(_VC_VERSION_1200 "6.0")     # Visual Studio 6.0
set(_VC_VERSION_1300 "7.0")     # Visual Studio 2002
set(_VC_VERSION_1310 "7.1")     # Visual Studio 2003
set(_VC_VERSION_1400 "8.0")     # Visual Studio 2005
set(_VC_VERSION_1500 "9.0")     # Visual Studio 2008
set(_VC_VERSION_1600 "10.0")    # Visual Studio 2010
set(_VC_VERSION_1700 "11.0")    # Visual Studio 2012
set(_VC_VERSION_1800 "12.0")    # Visual Studio 2013
set(_VC_VERSION_1900 "14.0")    # Visual Studio 2015

string(REGEX REPLACE "^([0-9]+)\\.([0-9]).*" "\\1\\2" _MSVC_VER ${CMAKE_CXX_COMPILER_VERSION})
set(_MSVC_VER "${_MSVC_VER}0")

set(LUA_MSVCRT "${_MSVCRT_${_MSVC_VER}}")
message("${_MSVC_VER}: ${LUA_MSVCRT}")

set(VC_VERSION ${_VC_VERSION_${_MSVC_VER}})


get_filename_component(ProductDir "[HKEY_LOCAL_MACHINE\\Software\\Microsoft\\VisualStudio\\${VC_VERSION}\\Setup\\VC;ProductDir]" ABSOLUTE)

set(_VCVARS_ARG_8 "amd64")
set(_VCVARS_ARG_4 "x86")

set(VCVARS_ARG ${_VCVARS_ARG_${CMAKE_SIZEOF_VOID_P}})
if(EXISTS "${ProductDir}/vcvarsall.bat")
  set(VCVARSALL "call \"${ProductDir}/vcvarsall.bat\" ${VCVARS_ARG}")
else()
  set(VCVARSALL "")
endif()

message("${VCVARSALL}")



add_subdirectory(lua/versions/${WITH_LUA})

if(WITH_LUAROCKS)
  add_subdirectory(luarocks)
endif(WITH_LUAROCKS)

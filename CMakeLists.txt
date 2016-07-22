cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(luainstaller)

# We want release compilation by default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

option(WITH_LUAROCKS "Install Luarocks" ON)


set(LUA_INCDIR "HOME/include") # Directory for the Lua headers"
set(LUA_LIBDIR "HOME") # Directory for Lua library
set(LUA_BINDIR "HOME") # Directory for Lua interpreter executable


set(_UNAME_M_FOR_BYTES_8 "x86_64")
set(_UNAME_M_FOR_BYTES_4 "x86")

# Configs
set(LUAROCKS_PREFIX "HOME")
set(LUAROCKS_SYSCONFDIR "HOME")
set(LUAROCKS_ROCKS_TREE "HOME")
set(LUAROCKS_ROCKS_SUBDIR "rocks")
set(LUAROCKS_UNAME_S "WindowsNT")
set(LUAROCKS_UNAME_M "${_UNAME_M_FOR_BYTES_${CMAKE_SIZEOF_VOID_P}}")
set(LUAROCKS_DOWNLOADER "wget")
set(LUAROCKS_MD5CHECKER "md5sum")
set(LUAROCKS_BINDIR "HOME")
set(LUAROCKS_CMODDIR "HOME/lib")
set(LUAROCKS_LUADIR "HOME/lua")


message("${CMAKE_CXX_COMPILER_VERSION}")


string(REGEX REPLACE "^([0-9]+)\\.([0-9]).*" "\\1\\2" _MSVC_VER ${CMAKE_CXX_COMPILER_VERSION})
set(_MSVC_VER "${_MSVC_VER}0")

# Set linked Visual Studio runtime DLL name
set(_MSVCRT_1200 "MSVCRT")      # Visual Studio 6.0
set(_MSVCRT_1300 "MSVCR70")     # Visual Studio 2002
set(_MSVCRT_1310 "MSVCR71")     # Visual Studio 2003
set(_MSVCRT_1400 "MSVCR80")     # Visual Studio 2005
set(_MSVCRT_1500 "MSVCR90")     # Visual Studio 2008
set(_MSVCRT_1600 "MSVCR100")    # Visual Studio 2010
set(_MSVCRT_1700 "MSVCR110")    # Visual Studio 2012
set(_MSVCRT_1800 "MSVCR120")    # Visual Studio 2013
set(_MSVCRT_1900 "VCRUNTIME140")# Visual Studio 2015
set(LUA_MSVCRT "${_MSVCRT_${_MSVC_VER}}")

# Set required Visual Studio version for compilation Lua c modules.
set(_VC_VERSION_1200 "6.0")     # Visual Studio 6.0
set(_VC_VERSION_1300 "7.0")     # Visual Studio 2002
set(_VC_VERSION_1310 "7.1")     # Visual Studio 2003
set(_VC_VERSION_1400 "8.0")     # Visual Studio 2005
set(_VC_VERSION_1500 "9.0")     # Visual Studio 2008
set(_VC_VERSION_1600 "10.0")    # Visual Studio 2010
set(_VC_VERSION_1700 "11.0")    # Visual Studio 2012
set(_VC_VERSION_1800 "12.0")    # Visual Studio 2013
set(_VC_VERSION_1900 "14.0")    # Visual Studio 2015
set(VC_VERSION ${_VC_VERSION_${_MSVC_VER}})     # Visual Studio version string in x.y format

# Set required Visual Studio name
set(_VC_NAME_1200 "6.0")     # Visual Studio 6.0
set(_VC_NAME_1300 "2002")     # Visual Studio 2002
set(_VC_NAME_1310 "2003")     # Visual Studio 2003
set(_VC_NAME_1400 "2005")     # Visual Studio 2005
set(_VC_NAME_1500 "2008")     # Visual Studio 2008
set(_VC_NAME_1600 "2010")    # Visual Studio 2010
set(_VC_NAME_1700 "2012")    # Visual Studio 2012
set(_VC_NAME_1800 "2013")    # Visual Studio 2013
set(_VC_NAME_1900 "2015")    # Visual Studio 2015
set(VC_NAME ${_VC_NAME_${_MSVC_VER}})     # Visual Studio name string

# Set required Windows SDK version for compilation Lua c modules.
# Only Windows SDK v7.1 and v6.1 shipped with compilers
# Other versions requires a separate installation of Visual Studio.
# see https://github.com/keplerproject/luarocks/pull/443#issuecomment-152792516
set(_WSDK_VERSION_1600 "7.1") # shipped with Visual Studio 2010 compilers.
set(_WSDK_VERSION_1500 "6.1") # shipped with Visual Studio 2008 compilers.
set(WSDK_VERSION ${_WSDK_VERSION_${_MSVC_VER}}) # required Windows SDK version in x.y format


# Set Lua CUP architecture.
set(_VCVARS_ARG_8 "amd64")
set(_VCVARS_ARG_4 "x86")
set(LUA_CPUARCH ${_VCVARS_ARG_${CMAKE_SIZEOF_VOID_P}})

set(_PACKAGE_ARCH_NAME_8 "x64")
set(_PACKAGE_ARCH_NAME_4 "x86")
set(PACKAGE_ARCH_NAME ${_PACKAGE_ARCH_NAME_${CMAKE_SIZEOF_VOID_P}})

set(_INNO_PF_8 "pf64")
set(_INNO_PF_4 "pf32")
set(INNO_PF ${_INNO_PF_${CMAKE_SIZEOF_VOID_P}})

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install)
set(LUAINSTALLER_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
include(luarocks/CMakeLists.txt)


add_subdirectory(lua/versions)

configure_file("LuaInstaller.iss" "${CMAKE_INSTALL_PREFIX}/LuaInstaller.iss")

add_custom_target(
  pack
  COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_BINARY_DIR} --config Release --target install
  COMMAND "iscc" "${CMAKE_INSTALL_PREFIX}/LuaInstaller.iss" /O. /FLuaInstaller-vs${VC_NAME}-${PACKAGE_ARCH_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

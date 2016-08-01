if (NOT MSVC)
  message(FATAL_ERROR "This is a msvc only project.")
endif()

string(REGEX REPLACE "^([0-9]+)\\.([0-9]).*" "\\1\\2" _MSVC_VER ${CMAKE_CXX_COMPILER_VERSION})
set(_MSVC_VER "${_MSVC_VER}0")

# Set linked Visual Studio runtime DLL name
set(_MSVCRT_1500 "MSVCR90")     # Visual Studio 2008
set(_MSVCRT_1600 "MSVCR100")    # Visual Studio 2010
set(_MSVCRT_1700 "MSVCR110")    # Visual Studio 2012
set(_MSVCRT_1800 "MSVCR120")    # Visual Studio 2013
set(_MSVCRT_1900 "VCRUNTIME140")# Visual Studio 2015
set(LUA_MSVCRT "${_MSVCRT_${_MSVC_VER}}")

# Set required Visual Studio version for compilation Lua c modules.
set(_VC_VERSION_1500 "9.0")     # Visual Studio 2008
set(_VC_VERSION_1600 "10.0")    # Visual Studio 2010
set(_VC_VERSION_1700 "11.0")    # Visual Studio 2012
set(_VC_VERSION_1800 "12.0")    # Visual Studio 2013
set(_VC_VERSION_1900 "14.0")    # Visual Studio 2015
set(VC_VERSION ${_VC_VERSION_${_MSVC_VER}})     # Visual Studio version string in x.y format

# Set required Visual Studio name
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

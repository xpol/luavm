cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(luainstaller)

# We want release compilation by default
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

option(WITH_LUAROCKS "Install Luarocks" ON)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install)

include(cmake/msvc.cmake) # load msvc variables
include(cmake/luarocks.cmake)
include(cmake/lua.cmake)

add_lua(VERSION 5.1 ABI 51 ROOT ${CMAKE_CURRENT_SOURCE_DIR}/lua/versions/lua-5.1)
add_lua(VERSION 5.2 ABI 52 ROOT ${CMAKE_CURRENT_SOURCE_DIR}/lua/versions/lua-5.2)
add_lua(VERSION 5.3 ABI 53 ROOT ${CMAKE_CURRENT_SOURCE_DIR}/lua/versions/lua-5.3)
add_jit(VERSION 2.0 ABI 51 ROOT ${CMAKE_CURRENT_SOURCE_DIR}/lua/versions/luajit-2.0)
add_jit(VERSION 2.1 ABI 51 ROOT ${CMAKE_CURRENT_SOURCE_DIR}/lua/versions/luajit-2.1)

include(cmake/luavm.cmake)
include(cmake/pack.cmake)

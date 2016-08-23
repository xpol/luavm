include(cmake/luarocks.cmake)

# add_lua(VERSION 5.1 ABI 51 ROOT path/to/lua)
function(add_lua)
  cmake_parse_arguments(add_lua "" "VERSION;ABI;ROOT" "" ${ARGN} )
  #message("called add_lua(VERSION ${add_lua_VERSION} ABI ${add_lua_ABI} ROOT ${add_lua_ROOT})")
  include(cmake/versions/lua-${add_lua_ABI}.cmake) # uses add_lua_ROOT
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)

  # Shared library
  add_library(lua-${add_lua_VERSION}.shared SHARED ${LIBRARY_FILES})
  set_target_properties(lua-${add_lua_VERSION}.shared PROPERTIES OUTPUT_NAME lua${add_lua_ABI} COMPILE_DEFINITIONS LUA_BUILD_AS_DLL COMPILE_OPTIONS /wd4334)

  # Lua executable
  add_executable(lua-${add_lua_VERSION} ${add_lua_ROOT}/src/lua.c)
  set_target_properties(lua-${add_lua_VERSION} PROPERTIES OUTPUT_NAME lua)
  target_link_libraries(lua-${add_lua_VERSION} lua-${add_lua_VERSION}.shared)

  # Luac executable
  add_executable(luac-${add_lua_VERSION} ${LUAC_FILES})
  set_target_properties(luac-${add_lua_VERSION} PROPERTIES OUTPUT_NAME luac COMPILE_OPTIONS /wd4334)

  # Config luarocks for this Lua version.
  config_luarocks(${add_lua_VERSION} lua.exe lua${add_lua_ABI}.lib)

  # Install files
  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${add_lua_VERSION}")
  set_target_properties(lua-${add_lua_VERSION}.shared lua-${add_lua_VERSION} luac-${add_lua_VERSION}
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${PREFIX}"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE "${PREFIX}"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PREFIX}"
  )
  install(FILES ${LUA_HEADERS} DESTINATION "${PREFIX}/include")
endfunction()

# add_jit(VERSION 2.0 ABI 51 ROOT path/to/luajit)
function(add_jit)
  cmake_parse_arguments(add_luajit "" "VERSION;ABI;ROOT" "" ${ARGN})
  #message("called add_jit(VERSION ${add_luajit_VERSION} ABI ${add_luajit_ABI} ROOT ${add_luajit_ROOT}) ")

  set(LUA_VERSION luajit-${add_luajit_VERSION})
  set(HEADERS
    ${add_luajit_ROOT}/src/lauxlib.h
    ${add_luajit_ROOT}/src/lua.h
    ${add_luajit_ROOT}/src/lua.hpp
    ${add_luajit_ROOT}/src/luaconf.h
    ${add_luajit_ROOT}/src/luajit.h
    ${add_luajit_ROOT}/src/lualib.h
  )

  include(ExternalProject)

  ExternalProject_Add(${LUA_VERSION}
    SOURCE_DIR ${add_luajit_ROOT}/src
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND "${add_luajit_ROOT}/src/msvcbuild.bat"
    BUILD_BYPRODUCTS luajit.exe lua${add_luajit_ABI}.dll lua${add_luajit_ABI}.lib
    INSTALL_COMMAND ""
  )

  config_luarocks(${LUA_VERSION} luajit.exe lua${add_luajit_ABI}.lib)

  # Install files
  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${LUA_VERSION}")
  install(FILES
      ${add_luajit_ROOT}/src/luajit.exe
      ${add_luajit_ROOT}/src/lua${add_luajit_ABI}.dll
      ${add_luajit_ROOT}/src/lua${add_luajit_ABI}.lib
    DESTINATION "${PREFIX}")
  install(FILES ${add_luajit_ROOT}/src/luajit.exe DESTINATION "${PREFIX}" RENAME lua.exe)
  install(DIRECTORY ${add_luajit_ROOT}/src/jit DESTINATION "${PREFIX}/lua")
  install(FILES ${HEADERS} DESTINATION "${PREFIX}/include")
endfunction()

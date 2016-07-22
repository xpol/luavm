# add_lua(VERSION 5.1 ABI 51 LIBRARY_FILES ... LUAC_FILES ... HEADERS ...)
function(add_lua)
  cmake_parse_arguments(add_lua "" "VERSION;ABI" "LIBRARY_FILES;LUAC_FILES;HEADERS" ${ARGN} )
  message("called add_lua(VERSION ${add_lua_VERSION} ABI ${add_lua_ABI})")

  project(lua-${add_lua_VERSION})

  add_definitions(-D_CRT_SECURE_NO_WARNINGS)

  # Shared library
  add_library(lua-${add_lua_VERSION}.shared SHARED ${add_lua_LIBRARY_FILES})
  set_target_properties(lua-${add_lua_VERSION}.shared PROPERTIES OUTPUT_NAME lua${add_lua_ABI} COMPILE_DEFINITIONS LUA_BUILD_AS_DLL COMPILE_OPTIONS /wd4334)

  # Lua executable
  add_executable(lua-${add_lua_VERSION} src/lua.c)
  set_target_properties(lua-${add_lua_VERSION} PROPERTIES OUTPUT_NAME lua)
  target_link_libraries(lua-${add_lua_VERSION} lua-${add_lua_VERSION}.shared)

  # Luac executable
  add_executable(luac-${add_lua_VERSION} ${add_lua_LUAC_FILES})
  set_target_properties(luac-${add_lua_VERSION} PROPERTIES OUTPUT_NAME luac COMPILE_OPTIONS /wd4334)

  # Config luarocks for this Lua version.
  config_luarocks(${add_lua_VERSION} lua.exe lua${add_lua_ABI}.lib)

  # Install files
  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${add_lua_VERSION}")
  install(TARGETS lua-${add_lua_VERSION} lua-${add_lua_VERSION}.shared luac-${add_lua_VERSION} RUNTIME DESTINATION "${PREFIX}" LIBRARY DESTINATION "${PREFIX}" ARCHIVE DESTINATION "${PREFIX}")
  install(FILES ${add_lua_HEADERS} DESTINATION "${PREFIX}/include")
  install(DIRECTORY doc DESTINATION "${PREFIX}")

  # Install luarocks for this Lua version.
  install_luarocks(${add_lua_VERSION})
endfunction()

function(add_luajit)
  cmake_parse_arguments(add_luajit "" "VERSION;ABI" "" ${ARGN})
  message("called add_luajit(VERSION ${add_luajit_VERSION} ABI ${add_luajit_ABI})")
  project(luajit-${add_luajit_VERSION})

  set(LUA_VERSION luajit-${add_luajit_VERSION})
  set(HEADERS src/lua.h src/lua.hpp src/luaconf.h src/lauxlib.h src/lualib.h src/luajit.h)

  include(ExternalProject)

  ExternalProject_Add(${LUA_VERSION}
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/src/msvcbuild.bat"
    BUILD_BYPRODUCTS luajit.exe lua${add_luajit_ABI}.dll lua${add_luajit_ABI}.lib
    INSTALL_COMMAND ""
  )

  config_luarocks(${LUA_VERSION} luajit.exe lua${add_luajit_ABI}.lib)

  # Install files
  set(PREFIX "${CMAKE_INSTALL_PREFIX}/versions/${LUA_VERSION}")
  install(FILES src/luajit.exe src/lua${add_luajit_ABI}.dll src/lua${add_luajit_ABI}.lib DESTINATION "${PREFIX}")
  install(DIRECTORY src/jit DESTINATION "${PREFIX}/lua")
  install(FILES ${HEADERS} DESTINATION "${PREFIX}/include")
  install(DIRECTORY doc DESTINATION "${PREFIX}")

  install_luarocks(${LUA_VERSION})
endfunction()


add_subdirectory(lua-5.1)
add_subdirectory(lua-5.2)
add_subdirectory(lua-5.3)

add_subdirectory(luajit-2.0)
add_subdirectory(luajit-2.1)

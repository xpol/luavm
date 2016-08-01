include(cmake/msvc.cmake) # load VC_NAME

set(_INNO_PF_8 "pf64")
set(_INNO_PF_4 "pf32")
set(INNO_PF ${_INNO_PF_${CMAKE_SIZEOF_VOID_P}})

set(_PACKAGE_ARCH_NAME_8 "x64")
set(_PACKAGE_ARCH_NAME_4 "x86")
set(PACKAGE_ARCH_NAME ${_PACKAGE_ARCH_NAME_${CMAKE_SIZEOF_VOID_P}})

configure_file("${PROJECT_SOURCE_DIR}/templates/package/LuaInstaller.iss" "${CMAKE_INSTALL_PREFIX}/LuaInstaller.iss")

add_custom_target(
  pack
  COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_BINARY_DIR} --config Release --target install
  COMMAND "iscc" "${CMAKE_INSTALL_PREFIX}/LuaInstaller.iss" /O. /FLuaInstaller-vs${VC_NAME}-${PACKAGE_ARCH_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

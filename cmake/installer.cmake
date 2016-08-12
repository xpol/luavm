include(cmake/msvc.cmake) # load VC_NAME

set(_INNO_PF_8 "pf64")
set(_INNO_PF_4 "pf32")
set(INNO_PF ${_INNO_PF_${CMAKE_SIZEOF_VOID_P}})

set(_PACKAGE_ARCH_NAME_8 "x64")
set(_PACKAGE_ARCH_NAME_4 "x86")
set(PACKAGE_ARCH_NAME ${_PACKAGE_ARCH_NAME_${CMAKE_SIZEOF_VOID_P}})

set(PFNAME "ProgramFiles(x86)")
set(PF $ENV{${PFNAME}})

find_program(ISCC iscc PATHS "${PF}\\Inno Setup 5" "$ENV{ProgramFiles}\\Inno Setup 5")

message("${ISCC}")

configure_file("${PROJECT_SOURCE_DIR}/templates/package/LuaVM.iss" "${CMAKE_INSTALL_PREFIX}/LuaVM.iss")

add_custom_target(
  installer
  COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_CURRENT_BINARY_DIR} --config Release --target install
  COMMAND "${ISCC}" "${CMAKE_INSTALL_PREFIX}/LuaVM.iss" /O. /FLuaVM-vs${VC_NAME}-${PACKAGE_ARCH_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

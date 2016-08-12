configure_file("${PROJECT_SOURCE_DIR}/templates/luavm/luavm.lua" "${CMAKE_CURRENT_BINARY_DIR}/luavm/luavm.lua")
install(FILES
    "${PROJECT_SOURCE_DIR}/templates/luavm/luavm.cmd"
    "${CMAKE_CURRENT_BINARY_DIR}/luavm/luavm.lua"
    DESTINATION "${CMAKE_INSTALL_PREFIX}")

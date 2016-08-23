configure_file("${PROJECT_SOURCE_DIR}/luavm/luavm.lua" "${CMAKE_INSTALL_PREFIX}/luavm/luavm.lua")
install(FILES "${PROJECT_SOURCE_DIR}/luavm/luavm.cmd" DESTINATION "${CMAKE_INSTALL_PREFIX}/luavm")

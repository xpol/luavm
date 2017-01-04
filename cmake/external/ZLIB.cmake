include(ExternalProject)

ExternalProject_Add(
    ZLIB
    URL http://www.zlib.net/zlib-1.2.10.tar.gz
    URL_HASH SHA256=8d7e9f698ce48787b6e1c67e6bff79e487303e66077e25cb9784ac8835978017
    BUILD_IN_SOURCE 1
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
)

include(ExternalProject)

set(OpenSSL_URL https://www.openssl.org/source/openssl-1.0.2k.tar.gz)
set(OpenSSL_SHA256 6b3977c61f2aedf0f96367dcfb5c6e578cf37e7b8d913b4ecb6643c3cb88d8c0)
set(OpenSSL_PREFIX ${CMAKE_INSTALL_PREFIX}/externals)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    ExternalProject_Add(
        OpenSSL
        URL ${OpenSSL_URL}
        URL_HASH SHA256=${OpenSSL_SHA256}
        CONFIGURE_COMMAND perl Configure VC-WIN64A "--prefix=${OpenSSL_PREFIX}"
        BUILD_IN_SOURCE 1
        BUILD_COMMAND "ms\\do_win64a.bat" >NUL
            COMMAND nmake -S -f "ms\\ntdll.mak"
        INSTALL_COMMAND nmake -f "ms\\ntdll.mak" install
    )
else()
    ExternalProject_Add(
        OpenSSL
        URL ${OpenSSL_URL}
        URL_HASH SHA256=${OpenSSL_SHA256}
        CONFIGURE_COMMAND perl Configure VC-WIN32 "--prefix=${OpenSSL_PREFIX}"
        BUILD_IN_SOURCE 1
        BUILD_COMMAND "ms\\do_ms.bat" >NUL
            COMMAND "ms\\do_nasm.bat" >NUL
            COMMAND nmake -S -f "ms\\ntdll.mak"
        INSTALL_COMMAND nmake -f "ms\\ntdll.mak" install
    )
endif()

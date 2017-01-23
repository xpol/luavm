include(ExternalProject)

set(OpenSSL_URL https://www.openssl.org/source/openssl-1.0.2j.tar.gz)
set(OpenSSL_SHA256 e7aff292be21c259c6af26469c7a9b3ba26e9abaaffd325e3dccc9785256c431)
set(OpenSSL_PREFIX ${CMAKE_INSTALL_PREFIX}/externals)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    ExternalProject_Add(
        OpenSSL
        URL ${OpenSSL_URL}
        URL_HASH SHA256=${OpenSSL_SHA256}
        CONFIGURE_COMMAND perl Configure VC-WIN64A "--prefix=${OpenSSL_PREFIX}"
        BUILD_IN_SOURCE 1
        BUILD_COMMAND "ms\\do_win64a.bat"
            COMMAND nmake -f "ms\\ntdll.mak"
        INSTALL_COMMAND nmake -f "ms\\ntdll.mak" install
    )
else()
    ExternalProject_Add(
        OpenSSL
        URL ${OpenSSL_URL}
        URL_HASH SHA256=${OpenSSL_SHA256}
        CONFIGURE_COMMAND perl Configure VC-WIN32 "--prefix=${OpenSSL_PREFIX}"
        BUILD_IN_SOURCE 1
        BUILD_COMMAND "ms\\do_ms.bat"
            COMMAND "ms\\do_nasm.bat"
            COMMAND nmake -f "ms\\ntdll.mak"
        INSTALL_COMMAND nmake -f "ms\\ntdll.mak" install
    )
endif()

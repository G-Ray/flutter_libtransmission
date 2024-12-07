# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

include(VcpkgAndroid.cmake)
include(ExternalProject)

project(flutter_libtransmission_library VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 17)

# On Windows, build will probably fail due to https://gitlab.kitware.com/cmake/cmake/-/issues/25936
# Set a custom TRANSMISSION_PREFIX env var to avoid this
if (DEFINED ENV{TRANSMISSION_PREFIX})
        SET(TRANSMISSION_PREFIX $ENV{TRANSMISSION_PREFIX})
else()
        SET(TRANSMISSION_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/transmission-prefix")
endif()

SET(TRANSMISSION_BUILD_DIR "${TRANSMISSION_PREFIX}/src/transmission-build")

if(LINUX OR ANDROID OR APPLE)
        SET(LIBS
                ${TRANSMISSION_BUILD_DIR}/libtransmission/libtransmission.a
                ${TRANSMISSION_BUILD_DIR}/third-party/dht.bld/pfx/lib/libdht.a
                ${TRANSMISSION_BUILD_DIR}/third-party/jsonsl/libjsonsl.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libb64.bld/src/libb64.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libdeflate.bld/pfx/lib/libdeflate.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libevent.bld/pfx/lib/libevent.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libnatpmp.bld/pfx/lib/libnatpmp.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libpsl.bld/pfx/lib/libpsl.a
                ${TRANSMISSION_BUILD_DIR}/third-party/libutp.bld/libutp.a
                ${TRANSMISSION_BUILD_DIR}/third-party/miniupnpc.bld/pfx/lib/libminiupnpc.a
                ${TRANSMISSION_BUILD_DIR}/third-party/wildmat/libwildmat.a
        )
elseif(WIN32)
        SET(LIBS
                ${TRANSMISSION_BUILD_DIR}/libtransmission/$<CONFIG>/transmission.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/dht.bld/pfx/lib/dht.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/jsonsl/$<CONFIG>/jsonsl.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libb64.bld/src/$<CONFIG>/b64.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libdeflate.bld/pfx/lib/deflatestatic.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libevent.bld/pfx/lib/event.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libnatpmp.bld/pfx/lib/natpmp.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libpsl.bld/pfx/lib/psl.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/libutp.bld/$<CONFIG>/utp.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/miniupnpc.bld/pfx/lib/miniupnpc.lib
                ${TRANSMISSION_BUILD_DIR}/third-party/wildmat/$<CONFIG>/wildmat.lib
                Ws2_32
                Crypt32
                Iphlpapi
)
endif()

if(LINUX)
        SET(CMAKE_ARGS
                "-DCMAKE_C_FLAGS=-fPIC"
                "-DCMAKE_CXX_FLAGS=-fPIC"
        )
elseif (APPLE)
        string(REPLACE ";" "$<SEMICOLON>" CMAKE_OSX_ARCHITECTURES_ "${CMAKE_OSX_ARCHITECTURES}")
        SET(CMAKE_ARGS "-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES_}")
elseif (ANDROID)
        SET(CMAKE_ARGS
                "-DCMAKE_C_FLAGS=-fPIC"
                "-DCMAKE_CXX_FLAGS=-fPIC"
                "-DCMAKE_SYSTEM_NAME=${DCMAKE_SYSTEM_NAME}"
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=${CMAKE_EXPORT_COMPILE_COMMANDS}"
                "-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
                "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
                "-DANDROID_STL=${ANDROID_STL}"
                "-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
                "-DANDROID_ABI=${ANDROID_ABI}"
                "-DCMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}"
                "-DANDROID_NDK=${ANDROID_NDK}"
                "-DCMAKE_ANDROID_NDK=${CMAKE_ANDROID_NDK}"
        )
endif()

ExternalProject_Add(transmission
        PREFIX ${TRANSMISSION_PREFIX}
        GIT_REPOSITORY https://github.com/G-Ray/transmission.git
        GIT_TAG 305dc755fe6537f3325f14c9a981b52204688cb3 # on "4.0.x-pikatorrent"
        INSTALL_COMMAND ""
        CMAKE_ARGS
                ${CMAKE_ARGS}
                "-DVCPKG_INSTALLED_DIR=${VCPKG_INSTALLED_DIR}"
                "-DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}"
                "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
                "-DVCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET}"
                "-DENABLE_GTK=OFF"
                "-DENABLE_QT=OFF"
                "-DENABLE_MAC=OFF"
                "-DREBUILD_WEB=OFF"
                "-DINSTALL_WEB=OFF"
                "-DENABLE_UTILS=OFF"
                "-DENABLE_CLI=OFF"
                "-DENABLE_TESTS=OFF"
                "-DWITH_CRYPTO=openssl"
                "-DENABLE_DAEMON=OFF"
                "-DINSTALL_DOC=OFF"
                "-DINSTALL_LIB=OFF"
                "-DUSE_SYSTEM_EVENT2=OFF"
                "-DUSE_SYSTEM_DEFLATE=OFF"
                "-DUSE_SYSTEM_DHT=OFF"
                "-DUSE_SYSTEM_MINIUPNPC=OFF"
                "-DUSE_SYSTEM_NATPMP=OFF"
                "-DUSE_SYSTEM_UTP=OFF"
                "-DUSE_SYSTEM_B64=OFF"
                "-DUSE_SYSTEM_PSL=OFF"
        BUILD_BYPRODUCTS
        ${LIBS}
)

find_package(CURL REQUIRED)
find_package(OpenSSL REQUIRED)

add_library(flutter_libtransmission SHARED
        "flutter_libtransmission.cc"
)

add_dependencies(flutter_libtransmission transmission)

ExternalProject_Get_property(transmission SOURCE_DIR)
include_directories("${SOURCE_DIR}/libtransmission")

if(APPLE)
        # Use unified libs
        SET(DEPENDENCIES 
                ${CMAKE_SOURCE_DIR}/../macos/lib/libcrypto.a
                ${CMAKE_SOURCE_DIR}/../macos/lib/libssl.a
                ${CMAKE_SOURCE_DIR}/../macos/lib/libz.a
                ${CMAKE_SOURCE_DIR}/../macos/lib/libcurl.a
                "-framework Foundation"
                "-framework SystemConfiguration"
                "-framework Security"
        )
else()
        SET(DEPENDENCIES 
                OpenSSL::Crypto
                OpenSSL::SSL
                CURL::libcurl
        )
endif()

target_link_libraries(flutter_libtransmission
        ${DEPENDENCIES}
        "$<$<BOOL:${ANDROID}>:log>"
        ${LIBS}
)

set_target_properties(flutter_libtransmission PROPERTIES
        PUBLIC_HEADER flutter_libtransmission.h
        OUTPUT_NAME "flutter_libtransmission"
)

target_compile_definitions(flutter_libtransmission PUBLIC DART_SHARED_LIB)

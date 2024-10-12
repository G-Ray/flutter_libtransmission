# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

include(VcpkgAndroid.cmake)
include(ExternalProject)

project(flutter_libtransmission_library VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 17)

SET(TRANSMISSION_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/transmission-prefix/src/transmission-build")

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

ExternalProject_Add(transmission
        GIT_REPOSITORY https://github.com/G-Ray/transmission.git
        GIT_TAG 305dc755fe6537f3325f14c9a981b52204688cb3 # on "4.0.x-pikatorrent"
        INSTALL_COMMAND ""
        CMAKE_ARGS
        "-DCMAKE_C_FLAGS=-fPIC"
        "-DCMAKE_CXX_FLAGS=-fPIC"
        "-DCMAKE_SYSTEM_NAME=${DCMAKE_SYSTEM_NAME}"
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=${CMAKE_EXPORT_COMPILE_COMMANDS}"
        "-DCMAKE_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}"
        "-DVCPKG_TARGET_ANDROID=${VCPKG_TARGET_ANDROID}"
        "-DANDROID_STL=${ANDROID_STL}"
        "-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
        "-DANDROID_ABI=${ANDROID_ABI}"
        "-DCMAKE_ANDROID_ARCH_ABI=${CMAKE_ANDROID_ARCH_ABI}"
        "-DANDROID_NDK=${ANDROID_NDK}"
        "-DCMAKE_ANDROID_NDK=${CMAKE_ANDROID_NDK}"
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
        "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
        "-DCMAKE_BUILD_TYPE=Release"
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

target_link_libraries(flutter_libtransmission
        OpenSSL::Crypto
        OpenSSL::SSL
        CURL::libcurl
        "$<$<BOOL:${ANDROID}>:log>"
        ${LIBS})

set_target_properties(flutter_libtransmission PROPERTIES
        PUBLIC_HEADER flutter_libtransmission.h
        OUTPUT_NAME "flutter_libtransmission"
)

target_compile_definitions(flutter_libtransmission PUBLIC DART_SHARED_LIB)

# Find latest SDK
if(DEFINED ENV{TARGET_IOS_DEVICE})
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "" FORCE)
    execute_process(COMMAND /usr/bin/xcrun -sdk iphoneos --show-sdk-path
                    OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
else()
    set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "" FORCE)
    execute_process(COMMAND /usr/bin/xcrun -sdk iphonesimulator --show-sdk-path
                    OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_MACOSX_BUNDLE false)
set(CMAKE_OSX_DEPLOYMENT_TARGET "13.0")

include($ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

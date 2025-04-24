# flutter_libtransmission_example

## Getting Started

vcpkg needs to be initialized to compile openssl & curl for Windows & Android.

```sh
export VCPKG_ROOT="$(pwd)/vcpkg"
export VCPKG_MANIFEST_DIR=$(pwd)
# MacOS
export MACOSX_DEPLOYMENT_TARGET=10.14 # Should be same as defined in /macos/Runner.xcodeproj
# iOS
# VCPKG_TARGET_TRIPLET=arm64-ios-simulator
export IPHONEOS_DEPLOYMENT_TARGET=12 # Should be same as defined in /ios/Runner.xcodeproj
./vcpkg/bootstrap-vcpkg.sh # or ./vcpkg/bootstrap-vcpkg.bat on Windows
flutter run
```

On Windows, define a `TRANSMISSION_PREFIX` env var to avoid https://gitlab.kitware.com/cmake/cmake/-/issues/25936
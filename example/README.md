# flutter_libtransmission_example

Demonstrates how to use the flutter_libtransmission plugin.

## Getting Started

vcpkg needs to be initialized to compile openssl & curl for Windows & Android.

```sh
./vcpkg/bootstrap-vcpkg.sh # or ./vcpkg/bootstrap-vcpkg.bat on Windows
VCPKG_MANIFEST_DIR= #path to the folder containing vcpkg.json
VCPKG_ROOT=absolute/path/to/vcpkg # Define an env var pointing to the local vcpkg directory
```

On Windows, define a `TRANSMISSION_PREFIX` env var to avoid https://gitlab.kitware.com/cmake/cmake/-/issues/25936
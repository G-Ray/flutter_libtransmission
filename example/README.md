# flutter_libtransmission_example

# Development

You will need the flutter SDK to be installed on your platform.
Follow the guide at https://docs.flutter.dev/get-started/install.

## Linux

You might need to install `cmake`, `openssl`, `ninja`, `curl`.

```sh
flutter run # start the app in development mode
flutter build linux # release
```

## MacOS

```sh
export VCPKG_ROOT="$(pwd)/vcpkg"
export VCPKG_MANIFEST_DIR=$(pwd)
./vcpkg/bootstrap-vcpkg.sh
flutter run -d macos # start the app in development mode
```

## Windows:

```powershell
$Env:VCPKG_ROOT="$(pwd)/vcpkg"
$Env:VCPKG_MANIFEST_DIR="$(pwd)"
# Workaround for https://gitlab.kitware.com/cmake/cmake/-/issues/25936
$Env:TRANSMISSION_PREFIX="C:\Users\[YOUR_USER]\transmission-prefix"
.\vcpkg\bootstrap-vcpkg.bat
flutter run
```


## Android (Linux host)

Install & configure Android SDK/NDK first.

```sh
export VCPKG_ROOT="$(pwd)/vcpkg"
export VCPKG_MANIFEST_DIR=$(pwd)
./vcpkg/bootstrap-vcpkg.sh
flutter devices # List available devices
flutter run -d {device} # start the app in development mode
```

### iOS (From a MacOS host)

```sh
export VCPKG_ROOT="$(pwd)/vcpkg"
export VCPKG_MANIFEST_DIR=$(pwd)
./vcpkg/bootstrap-vcpkg.sh
flutter devices # List available devices
flutter run -d {device_id} # start the app in development mode
```

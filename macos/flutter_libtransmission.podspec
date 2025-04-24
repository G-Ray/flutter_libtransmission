#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_libtransmission.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_libtransmission'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'

  s.compiler_flags = '-std=c++17' 

  s.prepare_command = <<-CMD
                        ${VCPKG_ROOT}/vcpkg install --triplet=x64-osx openssl curl
                        ${VCPKG_ROOT}/vcpkg install --triplet=arm64-osx openssl curl
                        mkdir -p ./lib
                        lipo ${VCPKG_ROOT}/installed/arm64-osx/lib/libcrypto.a ${VCPKG_ROOT}/installed/x64-osx/lib/libcrypto.a -create -output lib/libcrypto.a
                        lipo ${VCPKG_ROOT}/installed/arm64-osx/lib/libcurl.a ${VCPKG_ROOT}/installed/x64-osx/lib/libcurl.a -create -output lib/libcurl.a
                        lipo ${VCPKG_ROOT}/installed/arm64-osx/lib/libssl.a ${VCPKG_ROOT}/installed/x64-osx/lib/libssl.a -create -output lib/libssl.a
                        lipo ${VCPKG_ROOT}/installed/arm64-osx/lib/libz.a ${VCPKG_ROOT}/installed/x64-osx/lib/libz.a -create -output lib/libz.a
                        cd ../src
                        mkdir -p ../macos/build
                        mkdir -p ../macos/Classes/libtransmission
                        cmake -B ../macos/build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_OSX_ARCHITECTURES='x86_64;arm64' -DCMAKE_TOOLCHAIN_FILE="${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
                        cmake --build ../macos/build
                        cp -r ../macos/build/transmission-prefix/src/transmission/libtransmission/*.h ../macos/Classes/libtransmission/
                        cp ../macos/build/transmission-prefix/src/transmission-build/libtransmission/libtransmission.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/dht.bld/pfx/lib/libdht.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/jsonsl/libjsonsl.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libb64.bld/src/libb64.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libdeflate.bld/pfx/lib/libdeflate.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libevent.bld/pfx/lib/libevent.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libevent.bld/pfx/lib/libevent.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libnatpmp.bld/pfx/lib/libnatpmp.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libpsl.bld/pfx/lib/libpsl.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/libutp.bld/libutp.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/miniupnpc.bld/pfx/lib/libminiupnpc.a ../macos/lib/
                        cp ../macos/build/transmission-prefix/src/transmission-build/third-party/wildmat/libwildmat.a ../macos/lib/
                   CMD

  s.vendored_libraries = 'lib/libtransmission.a', 'lib/libdht.a', 'lib/libjsonsl.a', 'lib/libb64.a', 'lib/libdeflate.a', 'lib/libevent.a', 'lib/libnatpmp.a', 'lib/libpsl.a', 'lib/libutp.a', 'lib/libminiupnpc.a', 'lib/libwildmat.a', 'lib/libz.a', 'lib/libcrypto.a', 'lib/libssl.a', 'lib/libcurl.a',

  s.frameworks    = 'SystemConfiguration', 'Foundation', 'Security'
end

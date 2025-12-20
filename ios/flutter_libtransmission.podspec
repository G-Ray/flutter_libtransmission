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
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'HEADER_SEARCH_PATHS' => '${PODS_TARGET_SRCROOT}/Classes' }
  s.swift_version = '5.0'

  s.compiler_flags = '-std=c++17'

  s.prepare_command = <<-CMD
                        mkdir -p ./lib
                        if [ -z ${TARGET_IOS_DEVICE+x} ]
                        then
                          # Simulator libs for x64 + arm64
                          ${VCPKG_ROOT}/vcpkg install --triplet=x64-ios openssl curl
                          ${VCPKG_ROOT}/vcpkg install --triplet=arm64-ios-simulator openssl curl
                          lipo ${VCPKG_ROOT}/installed/x64-ios/lib/libcrypto.a ${VCPKG_ROOT}/installed/arm64-ios-simulator/lib/libcrypto.a -create -output lib/libcrypto.a
                          lipo ${VCPKG_ROOT}/installed/x64-ios/lib/libcurl.a ${VCPKG_ROOT}/installed/arm64-ios-simulator/lib/libcurl.a -create -output lib/libcurl.a
                          lipo ${VCPKG_ROOT}/installed/x64-ios/lib/libssl.a ${VCPKG_ROOT}/installed/arm64-ios-simulator/lib/libssl.a -create -output lib/libssl.a
                          lipo ${VCPKG_ROOT}/installed/x64-ios/lib/libz.a ${VCPKG_ROOT}/installed/arm64-ios-simulator/lib/libz.a -create -output lib/libz.a
                        else
                          # arm64 libs for device
                          ${VCPKG_ROOT}/vcpkg install --triplet=arm64-ios openssl curl
                          cp "${VCPKG_ROOT}/installed/arm64-ios/lib/libcrypto.a" lib/libcrypto.a
                          cp "${VCPKG_ROOT}/installed/arm64-ios/lib/libcurl.a" lib/libcurl.a
                          cp "${VCPKG_ROOT}/installed/arm64-ios/lib/libssl.a" lib/libssl.a
                          cp "${VCPKG_ROOT}/installed/arm64-ios/lib/libz.a" lib/libz.a
                        fi
                        cd ../src
                        mkdir -p ../ios/build
                        mkdir -p ../ios/Classes/libtransmission
                        cmake -B ../ios/build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE="$(pwd)/ios.toolchain.cmake"
                        cmake --build ../ios/build
                        cp -r ../ios/build/transmission-prefix/src/transmission/libtransmission/*.h ../ios/Classes/libtransmission/
                        cp ../ios/build/transmission-prefix/src/transmission-build/libtransmission/libtransmission.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/crc32c.bld/pfx/lib/libcrc32c.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/dht.bld/pfx/lib/libdht.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libb64.bld/src/libb64.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libdeflate.bld/pfx/lib/libdeflate.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libevent.bld/pfx/lib/libevent.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libnatpmp.bld/pfx/lib/libnatpmp.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libpsl.bld/pfx/lib/libpsl.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/libutp.bld/libutp.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/miniupnp/miniupnpc.bld/pfx/lib/libminiupnpc.a ../ios/lib/
                        cp ../ios/build/transmission-prefix/src/transmission-build/third-party/wildmat/libwildmat.a ../ios/lib/
                   CMD

  s.vendored_libraries = 'lib/libtransmission.a', 'libcrc32c.a', 'lib/libdht.a', 'lib/libb64.a', 'lib/libdeflate.a', 'lib/libevent.a', 'lib/libnatpmp.a', 'lib/libpsl.a', 'lib/libutp.a', 'lib/libminiupnpc.a', 'lib/libwildmat.a', 'lib/libz.a', 'lib/libcrypto.a', 'lib/libssl.a', 'lib/libcurl.a'

  s.frameworks    = 'SystemConfiguration', 'Foundation', 'Security'
end

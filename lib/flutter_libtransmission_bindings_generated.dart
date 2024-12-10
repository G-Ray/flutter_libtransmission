// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for `src/flutter_libtransmission.h`.
///
/// Regenerate bindings with `dart run ffigen --config ffigen.yaml`.
///
class FlutterLibtransmissionBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  FlutterLibtransmissionBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  FlutterLibtransmissionBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// Initialize a transmission session given a config dir and an app name.
  void init_session(
    ffi.Pointer<ffi.Char> config_dir,
    ffi.Pointer<ffi.Char> app_name,
  ) {
    return _init_session(
      config_dir,
      app_name,
    );
  }

  late final _init_sessionPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)>>('init_session');
  late final _init_session = _init_sessionPtr.asFunction<
      void Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>)>();

  /// Close transmission session.
  void close_session() {
    return _close_session();
  }

  late final _close_sessionPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('close_session');
  late final _close_session = _close_sessionPtr.asFunction<void Function()>();

  /// Long running function which should be called asynchronously.
  /// This function will return a char pointer which should be freed.
  ffi.Pointer<ffi.Char> request(
    ffi.Pointer<ffi.Char> json_string,
  ) {
    return _request(
      json_string,
    );
  }

  late final _requestPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>>('request');
  late final _request = _requestPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>();

  /// Save current transmission settings to disk.
  void save_settings() {
    return _save_settings();
  }

  late final _save_settingsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('save_settings');
  late final _save_settings = _save_settingsPtr.asFunction<void Function()>();

  /// Reset all session settings
  void reset_settings() {
    return _reset_settings();
  }

  late final _reset_settingsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('reset_settings');
  late final _reset_settings = _reset_settingsPtr.asFunction<void Function()>();
}

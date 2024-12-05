import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'flutter_libtransmission_bindings_generated.dart';

const String _libName = 'flutter_libtransmission';

/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
void initSession(String configDir, String appName) => _bindings.init_session(
    configDir.toNativeUtf8().cast<Char>(), appName.toNativeUtf8().cast<Char>());

void closeSession() => _bindings.close_session();

void saveSettings() => _bindings.save_settings();

/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.
Future<String> requestAsync(String json) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextTransmissionRequestId++;
  final _TransmissionRequest request = _TransmissionRequest(requestId, json);
  final Completer<String> completer = Completer<String>();
  _requestRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

/// The dynamic library in which the symbols for [FlutterLibtransmissionBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FlutterLibtransmissionBindings _bindings =
    FlutterLibtransmissionBindings(_dylib);

/// A request to send to transmission.
///
/// Typically sent from one isolate to another.
class _TransmissionRequest {
  final int id;
  final String json;

  const _TransmissionRequest(this.id, this.json);
}

/// A response with the result of the request.
///
/// Typically sent from one isolate to another.
class _TransmissionRequestResponse {
  final int id;
  final String result;

  const _TransmissionRequestResponse(this.id, this.result);
}

/// Counter to identify [_TransmissionRequest]s and [_TransmissionRequestResponse]s.
int _nextTransmissionRequestId = 0;

/// Mapping from [_TransmissionRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<String>> _requestRequests = <int, Completer<String>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is _TransmissionRequestResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<String> completer = _requestRequests[data.id]!;
        _requestRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _TransmissionRequest) {
          final result =
              _bindings.request(data.json.toNativeUtf8().cast<Char>());
          String str = result.cast<Utf8>().toDartString();
          final _TransmissionRequestResponse response = _TransmissionRequestResponse(data.id, str);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();

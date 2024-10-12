import 'package:flutter_libtransmission/flutter_libtransmission.dart' as flutter_libtransmission;

class Transmission {
  void handleInit() {
    flutter_libtransmission.initSession('flutter_libtransmission_config', 'flutter_libtransmission');
  }

  Future<String> handleRequest (String jsonString) async {
    String res = await flutter_libtransmission.requestAsync(jsonString);
    return res;
  }

  void handleClose() {
    flutter_libtransmission.closeSession();
  }
}
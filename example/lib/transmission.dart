import 'dart:io';

import 'package:flutter_libtransmission/flutter_libtransmission.dart' as flutter_libtransmission;
import 'package:path_provider/path_provider.dart';

class Transmission {
  late String _tempDirectoryPath;

  void _cleanConfigDir () {
    // Clean existing dir if it exist
    if (Directory(_tempDirectoryPath).existsSync()) {
      Directory(_tempDirectoryPath).deleteSync(recursive: true);
    }
  }

  void initSession() async {
    final tmpDir = await getTemporaryDirectory();
    _tempDirectoryPath = '${tmpDir.path}/flutter_libtransmission_config';

    _cleanConfigDir();

    flutter_libtransmission.initSession(_tempDirectoryPath, 'flutter_libtransmission');
  }

  Future<String> requestAsync (String jsonString) async {
    String res = await flutter_libtransmission.requestAsync(jsonString);
    return res;
  }

  void closeSession() {
    flutter_libtransmission.closeSession();
    _cleanConfigDir();
  }
}
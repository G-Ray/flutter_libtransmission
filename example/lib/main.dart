import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_libtransmission/flutter_libtransmission.dart'
    as flutter_libtransmission;
import 'package:flutter_libtransmission_example/transmission.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String responseAsyncResult = 'Loading';
  Transmission transmission = Transmission();
  late String _tempDirectoryPath;

  @override
  void initState() {
    print('initState');
    super.initState();
  }

  void handleInit() async {
    final tmpDir = await getTemporaryDirectory();
    _tempDirectoryPath = '${tmpDir.path}/flutter_libtransmission_config';
    print('_tempDirectoryPath' + _tempDirectoryPath);

    // Clean existing dir if it exist
    if (Directory(_tempDirectoryPath).existsSync()) {
      print("exist !!!");
      Directory(_tempDirectoryPath).deleteSync(recursive: true);
    }

    flutter_libtransmission.initSession(
        _tempDirectoryPath, 'flutter_libtransmission');
  }

  void handleRequest() async {
    const jsonString = '''
      {
        "arguments": {
           "fields": [
             "version"
           ]
         },
         "method": "session-get"
      }
    ''';
    String res = await transmission.handleRequest(jsonString);
    setState(() {
      responseAsyncResult = res;
    });
  }

  void handleClose() {
    flutter_libtransmission.closeSession();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(responseAsyncResult,
                    style: textStyle, textAlign: TextAlign.center),
                MaterialButton(
                    onPressed: handleInit,
                    color: Colors.blue,
                    child: const Text('Init')),
                spacerSmall,
                MaterialButton(
                    onPressed: handleRequest,
                    color: Colors.blue,
                    child: const Text('Request')),
                spacerSmall,
                MaterialButton(
                    onPressed: handleClose,
                    color: Colors.blue,
                    child: const Text('Close'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

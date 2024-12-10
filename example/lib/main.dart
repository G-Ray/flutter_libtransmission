import 'package:flutter/material.dart';
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
  String responseAsyncResult = '';
  Transmission tr = Transmission();

  @override
  void initState() {
    super.initState();
  }

  void handleInit() async {
    tr.initSession();
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
    String res = await tr.requestAsync(jsonString);
    setState(() {
      responseAsyncResult = res;
    });
  }

  void handleClose() {
    tr.closeSession();
  }

  void handleResetSettings() {
    tr.resetSettings();
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
                    onPressed: handleResetSettings,
                    color: Colors.blue,
                    child: const Text('Reset settings')),
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

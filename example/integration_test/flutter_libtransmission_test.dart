import 'dart:convert';

import 'package:flutter_libtransmission_example/transmission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      Transmission tr = Transmission();

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

      tr.handleInit();

      String res = await tr.handleRequest(jsonString);

      expect(jsonDecode(res)['result'], "success");

      tr.handleClose();
    });
  });
}

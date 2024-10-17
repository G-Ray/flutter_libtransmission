import 'dart:convert';

import 'package:flutter_libtransmission_example/transmission.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration tests', () {
    testWidgets('session-get should return result success',
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

      tr.initSession();

      String res = await tr.requestAsync(jsonString);

      expect(jsonDecode(res)['result'], "success");

      tr.closeSession();
    });
  });
}

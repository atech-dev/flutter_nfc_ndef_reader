import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nfc_ndef_reader/flutter_nfc_ndef_reader_method_channel.dart';

void main() {
  MethodChannelFlutterNfcNdefReader platform =
      MethodChannelFlutterNfcNdefReader();
  const MethodChannel channel = MethodChannel('flutter_nfc_ndef_reader');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await platform.getPlatformVersion(), '42');
  });
}

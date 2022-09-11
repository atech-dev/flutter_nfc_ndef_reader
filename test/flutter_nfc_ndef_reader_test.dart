import 'package:flutter_nfc_ndef_reader/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nfc_ndef_reader/flutter_nfc_ndef_reader.dart';
import 'package:flutter_nfc_ndef_reader/flutter_nfc_ndef_reader_platform_interface.dart';
import 'package:flutter_nfc_ndef_reader/flutter_nfc_ndef_reader_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNfcNdefReaderPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNfcNdefReaderPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> handleOnDiscovered(arguments) {
    // TODO: implement handleOnDiscovered
    throw UnimplementedError();
  }

  @override
  Future<void> handleOnError(arguments) {
    // TODO: implement handleOnError
    throw UnimplementedError();
  }

  @override
  Future<bool?> isAvailable() {
    // TODO: implement isAvailable
    throw UnimplementedError();
  }

  @override
  Future<void> startSession(
      {String? alertMessage,
      NfcNdefDiscoveredCallback? onDiscovered,
      NfcOnErrorCallback? onError}) {
    // TODO: implement startNfcEmulator
    throw UnimplementedError();
  }

  @override
  Future<void> stopSession(String? alertMessage) {
    // TODO: implement stopNfcEmulator
    throw UnimplementedError();
  }
}

void main() {
  final FlutterNfcNdefReaderPlatform initialPlatform =
      FlutterNfcNdefReaderPlatform.instance;

  test('$MethodChannelFlutterNfcNdefReader is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNfcNdefReader>());
  });

  test('getPlatformVersion', () async {
    FlutterNfcNdefReader flutterNfcNdefReaderPlugin = FlutterNfcNdefReader();
    MockFlutterNfcNdefReaderPlatform fakePlatform =
        MockFlutterNfcNdefReaderPlatform();
    FlutterNfcNdefReaderPlatform.instance = fakePlatform;

    // expect(await flutterNfcNdefReaderPlugin.getPlatformVersion(), '42');
  });
}

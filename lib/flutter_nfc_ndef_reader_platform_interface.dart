import 'package:flutter_nfc_ndef_reader/types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_nfc_ndef_reader_method_channel.dart';

abstract class FlutterNfcNdefReaderPlatform extends PlatformInterface {
  /// Constructs a FlutterNfcNdefReaderPlatform.
  FlutterNfcNdefReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNfcNdefReaderPlatform _instance =
      MethodChannelFlutterNfcNdefReader();

  /// The default instance of [FlutterNfcNdefReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNfcNdefReader].
  static FlutterNfcNdefReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNfcNdefReaderPlatform] when
  /// they register themselves.
  static set instance(FlutterNfcNdefReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startSession({
    String? alertMessage,
    NfcNdefDiscoveredCallback? onDiscovered,
    NfcOnErrorCallback? onError,
  }) {
    throw UnimplementedError('startSession() has not been implemented.');
  }

  Future<void> stopSession(String? alertMessage) {
    throw UnimplementedError('stopSession() has not been implemented.');
  }

  Future<bool?> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  Future<void> handleOnDiscovered(dynamic arguments) {
    throw UnimplementedError('handleOnDiscovered() has not been implemented.');
  }

  Future<void> handleOnError(dynamic arguments) {
    throw UnimplementedError('handleOnError() has not been implemented.');
  }
}

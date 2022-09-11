import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_ndef_reader/types.dart';

import 'flutter_nfc_ndef_reader_platform_interface.dart';

/// An implementation of [FlutterNfcNdefReaderPlatform] that uses method channels.
class MethodChannelFlutterNfcNdefReader extends FlutterNfcNdefReaderPlatform {
  late NfcNdefDiscoveredCallback? onDiscoveredCall;
  late NfcOnErrorCallback? onErrorCall;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_nfc_ndef_reader');

  /// Start the session and register callbacks for tag discovery.
  ///
  /// This uses the NFCTagReaderSession (on iOS) or NfcAdapter#enableReaderMode (on Android).
  /// Requires iOS 13.0 or Android API 19, or later.
  ///
  /// `onDiscovered` is called whenever the tag is discovered.
  ///
  /// (iOS only) `alertMessage` is used to display the message on the popup shown when the session is started.
  ///
  /// (iOS only) `onError` is called when the session is stopped for some reason after the session has started.
  @override
  Future<void> startSession({
    NfcNdefDiscoveredCallback? onDiscovered,
    String? alertMessage,
    NfcOnErrorCallback? onError,
  }) async {
    onDiscoveredCall = onDiscovered;
    onErrorCall = onError;
    methodChannel.setMethodCallHandler(_handleMethodCall);
    await methodChannel.invokeMethod<dynamic>('Nfc#startSession', {
      'alertMessage': alertMessage,
    });
  }

  @override
  Future<void> stopSession(
    String? alertMessage,
  ) async {
    await methodChannel.invokeMethod<dynamic>('Nfc#stopSession', {
      'alertMessage': alertMessage,
    });
  }

  /// Checks whether the NFC features are available.
  @override
  Future<bool> isAvailable() async {
    return methodChannel
        .invokeMethod('Nfc#isAvailable')
        .then((value) => value!);
  }

  // handleOnDiscovered
  @override
  Future<void> handleOnDiscovered(dynamic arguments) async {
    if (arguments != null) {
      if (arguments is String) {
        // To remove the '\^en' String from the emulator
        String str = arguments;
        var index = str.indexOf(" ");
        if (index != -1) {
          arguments = str.substring(index + 1);
        }
      }
    }

    onDiscoveredCall?.call(arguments);
  }

  // handleOnError
  @override
  Future<void> handleOnError(dynamic arguments) async {
    onErrorCall?.call(arguments);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onDiscovered':
        handleOnDiscovered(call.arguments);
        break;
      case 'onError':
        handleOnError(call);
        break;
      default:
        throw ('Not implemented: ${call.method}');
    }
  }
}

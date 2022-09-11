import 'package:flutter_nfc_ndef_reader/types.dart';

import 'flutter_nfc_ndef_reader_platform_interface.dart';

class FlutterNfcNdefReader {
  /// Start Session session and register callbacks for device read.
  ///
  /// This uses the NfcAdapter#enableReaderMode (on Android).
  /// Requires Android API 19, or later.
  ///
  /// `text` Any text greater than 10 Characthers
  ///
  /// `onReadEmulatorFinished` is called whenever the tag is discovered.
  static Future<void> startSession({
    String? alertMessage,
    NfcNdefDiscoveredCallback? onDiscovered,
    NfcOnErrorCallback? onError,
  }) async {
    await FlutterNfcNdefReaderPlatform.instance.startSession(
      alertMessage: alertMessage,
      onDiscovered: onDiscovered,
      onError: onError,
    );
  }

  /*
   * Stop NFC Emulator
   */
  static Future<void> stopSession({String? alertMessage}) async {
    // await FlutterNfcNdefReaderPlatform.instance.handleOnDiscovered(null);
    await FlutterNfcNdefReaderPlatform.instance.stopSession(alertMessage);
  }

  /*
   * Is available
   */
  static Future<bool?> isAvailable() async {
    return FlutterNfcNdefReaderPlatform.instance.isAvailable();
  }
}

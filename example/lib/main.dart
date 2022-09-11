import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_nfc_ndef_reader/flutter_nfc_ndef_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? ndefText;
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      var isAvailable = await FlutterNfcNdefReader.isAvailable();
      if (isAvailable ?? false) {
        await FlutterNfcNdefReader.startSession(
          alertMessage: "YAYA",
          onDiscovered: (data) async {
            print("data - : $data");

            if (data != null) {
              ndefText = data;

              setState(() {});
            }

            await Future.delayed(const Duration(seconds: 1));
            await FlutterNfcNdefReader.stopSession(
              alertMessage: "STOP BABA",
            );
          },
          onError: (e) {
            print("onError: $e");
          },
        );
        // platformVersion = await _flutterNfcNdefReaderPlugin.getPlatformVersion() ?? 'Unknown platform version';
      } else {
        print("IS not available");
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /*
    setState(() {
      _platformVersion = platformVersion;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await initPlatformState();
                },
                child: const Text(
                  'READ NDEF',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ndefText == null
                  ? Container()
                  : Text(
                      ndefText!,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

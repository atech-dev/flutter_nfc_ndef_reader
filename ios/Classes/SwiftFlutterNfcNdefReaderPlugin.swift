import Foundation
import CoreNFC
import Flutter
import UIKit

public class SwiftFlutterNfcNdefReaderPlugin: NSObject, FlutterPlugin {

  private let channel: FlutterMethodChannel

  @available(iOS 13.0, *)
  private lazy var session: NFCNDEFReaderSession? = nil

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_nfc_ndef_reader", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterNfcNdefReaderPlugin(channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private init(_ channel: FlutterMethodChannel) {
    self.channel = channel
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 13.0, *) else {
      result(FlutterError(code: "unavailable", message: "Only available in iOS 13.0 or newer", details: nil))
      return
    }

    switch call.method {
      case "Nfc#isAvailable": handleIsAvailable(call.arguments, result: result)
      case "Nfc#startSession": handleStartSession(call.arguments as! [String : Any?], result: result)
      case "Nfc#stopSession": handleStopSession(call.arguments as! [String : Any?], result: result)
      default: result(FlutterMethodNotImplemented)
    }
  }

  @available(iOS 13.0, *)
  private func handleIsAvailable(_ arguments: Any?, result: @escaping FlutterResult) {
    result(NFCNDEFReaderSession.readingAvailable)
  }

  @available(iOS 13.0, *)
  private func handleStartSession(_ arguments: [String : Any?], result: @escaping FlutterResult) {
    session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    if let alertMessage = arguments["alertMessage"] as? String { session?.alertMessage = alertMessage }
    session?.begin()
    result(nil)
  }

  @available(iOS 13.0, *)
  private func handleStopSession(_ arguments: [String : Any?], result: @escaping FlutterResult) {
    guard let session = session else {
      result(nil)
      return
    }

    if let errorMessage = arguments["errorMessage"] as? String {
      session.invalidate(errorMessage: errorMessage)
      self.session = nil
      result(nil)
    }

    if let alertMessage = arguments["alertMessage"] as? String { session.alertMessage = alertMessage }
    session.invalidate()
    self.session = nil
    result(nil)
  }

  @available(iOS 11.0, *)
  func getErrorTypeString(_ arg: NFCReaderError.Code) -> String? {
    // TODO: add more cases
    switch arg {
    case .readerSessionInvalidationErrorSessionTimeout: return "sessionTimeout"
    case .readerSessionInvalidationErrorSystemIsBusy: return "systemIsBusy"
    case .readerSessionInvalidationErrorUserCanceled: return "userCanceled"
    default: return nil
    }
  }

  @available(iOS 11.0, *)
  func getErrorMap(_ arg: Error) -> [String : Any?] {
    if let arg = arg as? NFCReaderError {
      return [
        "type": getErrorTypeString(arg.code),
        "message": arg.localizedDescription,
        "details": nil,
      ]
    }
    return [
      "type": nil,
      "message": arg.localizedDescription,
      "details": nil,
    ]
  }
}

@available(iOS 13.0, *)
extension SwiftFlutterNfcNdefReaderPlugin: NFCNDEFReaderSessionDelegate {
    
    public func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // no op
    }

  public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    self.channel.invokeMethod("onError", arguments: getErrorMap(error))
  }
  
  public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    
    print("Detected NDEF")
    var payload = ""
    for message in messages {
      for record in message.records {
        // print(record.identifier)
        // print(record.payload)
        // print(String(data: record.payload, encoding: .utf8))
        // print(record.type)
        // print(record.typeNameFormat)
        
        // payload += "\(record.identifier)\n"
        // payload += "\(record.payload)\n"
        // payload += "\(record.type)\n"
        // payload += "\(record.typeNameFormat)\n"
        
        if let resultString = String(data: record.payload, encoding: .utf8) {
          // onNFCResult(true, resultString)
          self.channel.invokeMethod("onDiscovered", arguments: resultString)
        }
      }
    }
  }
}


import Flutter
import UIKit
import GoogleMaps
import Firebase
import FirebaseMessaging
import flutter_callkit_incoming
import app_links
import PushKit
import os.log
import Foundation
import UserNotifications
import AVFoundation
import CoreNFC
import PassKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    // Explicitly create and manage the Flutter Engine.
    lazy var flutterEngine = FlutterEngine(name: "io.flutter")
    var voipRegistry: PKPushRegistry!
    
    /* override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
         let userInfo = response.notification.request.content.userInfo
         
         // Handle return to call notification
         if response.notification.request.content.categoryIdentifier == "RETURN_TO_CALL",
            let callDataJSON = userInfo["call_data"] as? Foundation.Data,
            let callData = try? JSONSerialization.jsonObject(with: callDataJSON) as? [String: Any] {
             
             NSLog("Return to call notification tapped")
             
             // Send call data to Flutter
             let channel = FlutterMethodChannel(name: "com.marker.flutter.voip/token", binaryMessenger: self.flutterEngine.binaryMessenger)
             channel.invokeMethod("onReturnToCallNotification", arguments: callData)
         }
         
         completionHandler()
     } */
     
    /* override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         // Show notification even when app is in foreground
         completionHandler([.banner, .sound])
     } */

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // ** THE FIX - Part 1: Configure native SDKs FIRST. **
        // This MUST be done before any Flutter plugins are registered.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDOXWtPoDiHvpbrAMKffhIAWmjkp4HPAJ8")

        // Set up notification center delegate
//         UNUserNotificationCenter.current().delegate = self

        // Start the Flutter engine as soon as possible.
        flutterEngine.run()

        // Register all plugins with the configured engine.
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        // When using a long-lived engine, we are responsible for creating the view controller.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let flutterViewController = FlutterViewController(engine: self.flutterEngine, nibName: nil, bundle: nil)
        self.window?.rootViewController = flutterViewController
        self.window?.makeKeyAndVisible()
        
        // ** THE FIX - Part 2: Let plugins handle their own delegates. **
        // Do NOT manually set the UNUserNotificationCenter delegate; the Firebase plugin does this.
        application.registerForRemoteNotifications()

        // It's crucial to register for VoIP pushes as early as possible.
        voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]

        // Set up NFC method channel
        let nfcChannel = FlutterMethodChannel(
            name: "marker.app/nfc",
            binaryMessenger: self.flutterEngine.binaryMessenger
        )
        nfcChannel.setMethodCallHandler { (call, result) in
            if call.method == "isNfcEnabled" {
                // Check if device supports Tap to Pay (Proximity Reader)
                // Requires iOS 15.4+ and iPhone XS or later
                if #available(iOS 15.4, *) {
                    // Check for Proximity Reader payment acceptance capability
                    // This is the proper check for Stripe Tap to Pay support
                    let canAcceptPayments = PKPaymentAuthorizationController.canMakePayments()
                    result(canAcceptPayments)
                } else {
                    result(false)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        // Set up method channel using the stable engine's binary messenger.
        let channel = FlutterMethodChannel(
            name: "com.marker.flutter.voip/token",
            binaryMessenger: self.flutterEngine.binaryMessenger
        )
        channel.setMethodCallHandler { (call, result) in
            if call.method == "getVoipToken" {
                let token = UserDefaults.standard.string(forKey: "voip_token")
                result(token)
            } /* else if call.method == "checkActiveCall" {
                let hasActiveCall = UserDefaults.standard.bool(forKey: "has_active_call")
                let callData = UserDefaults.standard.dictionary(forKey: "last_incoming_call_data")
                let callTime = UserDefaults.standard.object(forKey: "call_received_time") as? Date
                let isCallValid = callTime != nil && Date().timeIntervalSince(callTime!) < 300 // 5 minutes
                result(["hasActiveCall": hasActiveCall && isCallValid, "callData": callData ?? [:], "isValid": isCallValid])
            } else if call.method == "clearActiveCall" {
                UserDefaults.standard.removeObject(forKey: "has_active_call")
                UserDefaults.standard.removeObject(forKey: "last_incoming_call_data")
                UserDefaults.standard.removeObject(forKey: "call_received_time")
                result(nil)
            } else if call.method == "needsMediaReinit" {
                let needsReinit = UserDefaults.standard.bool(forKey: "needs_media_reinit")
                result(needsReinit)
            } else if call.method == "getVoipWakeupData" {
                let wakeupData = UserDefaults.standard.dictionary(forKey: "voip_wakeup_data")
                result(wakeupData ?? [:])
            } else if call.method == "shouldReturnToCall" {
                let shouldReturn = UserDefaults.standard.bool(forKey: "should_return_to_call")
                result(shouldReturn)
            } else if call.method == "getReturnToCallData" {
                let callData = UserDefaults.standard.dictionary(forKey: "return_to_call_data")
                result(callData ?? [:])
            } else if call.method == "clearReturnToCall" {
                UserDefaults.standard.removeObject(forKey: "should_return_to_call")
                UserDefaults.standard.removeObject(forKey: "return_to_call_data")
                result(nil)
            } else if call.method == "onReturnToCallNotification" {
                // Handle return to call from notification
                if let callData = call.arguments as? [String: Any] {
                    // Store call data for Flutter to handle
                    UserDefaults.standard.set(callData, forKey: "return_to_call_data")
                    UserDefaults.standard.set(true, forKey: "should_return_to_call")
                    result(nil)
                }
            } else if call.method == "clearVoipWakeup" {
                UserDefaults.standard.removeObject(forKey: "needs_media_reinit")
                UserDefaults.standard.removeObject(forKey: "voip_wakeup_data")
                result(nil)
            } else if call.method == "onVoipWakeUp" {
                // Handle VoIP wake-up from Dart
                if let callData = call.arguments as? [String: Any] {
                    UserDefaults.standard.set(callData, forKey: "voip_wakeup_data")
                    UserDefaults.standard.set(true, forKey: "needs_media_reinit")
                    result(nil)
                }
            } */
        }

        // Handle deep links
        if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
            AppLinks.shared.handleLink(url: url)
        }

        // Return true to indicate that we have handled the launch process.
        return true
    }
}

// MARK: - PushKit Delegate
extension AppDelegate: PKPushRegistryDelegate {

    // Called when a new VoIP token is generated
    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        NSLog("VoIP Token: %@", token)
        
        // Send token to Flutter using the stable engine's binary messenger
        let channel = FlutterMethodChannel(name: "com.marker.flutter.voip/token", binaryMessenger: self.flutterEngine.binaryMessenger)
        channel.invokeMethod("onVoipToken", arguments: token)

        // Save token to UserDefaults
        UserDefaults.standard.set(token, forKey: "voip_token")
    }

    // Incoming VoIP Push
    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        guard let dict = payload.dictionaryPayload as? [String: Any] else {
            os_log("VoIP push payload was not a dictionary", type: .error)
            completion()
            return
        }

        NSLog("📩 VoIP Push Received: %@", dict.description)

        if let data = dict["data"] as? [String: Any], let type = data["type"] as? String, type == "call_ended" {
            if let uuid = dict["uuid"] as? String {
                let callData: [String: Any] = ["id": uuid]
                let data = flutter_callkit_incoming.Data(args: callData)
                SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(data)
            } else {
                SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endAllCalls()
            }
            completion()
            return
        } else if let data = dict["data"] as? [String: Any], let type = data["type"] as? String, type == "call_rejected" {
            if let uuid = dict["uuid"] as? String {
                let callData: [String: Any] = ["id": uuid]
                let data = flutter_callkit_incoming.Data(args: callData)
                SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(data)
            } else {
                SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endAllCalls()
            }
            completion()
            return
        } else {
            // The flutter_callkit_incoming plugin internally handles waking the Flutter engine
            // if needed. We just need to provide the payload data.
            let callData = self.buildCallKitPayload(from: dict)
            let callkitData = flutter_callkit_incoming.Data(args: callData)
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(callkitData, fromPushKit: true)
        }

        
        
        completion()
    }
    
    // Helper function to construct the payload for flutter_callkit_incoming
    private func buildCallKitPayload(from dict: [String: Any]) -> [String: Any] {
        let callId =  dict["uuid"] as? String ?? UUID().uuidString
        let callerName = dict["name"] as? String ?? ""
        let handle = dict["channel"] as? String ?? ""
        let profileUrl = dict["profile"] as? String ?? ""

        // Custom data for your Dart app
        let customData: [String: Any] = [
            "channel": handle,
            "name": callerName,
            "profile": profileUrl,
            "type": dict["type"] ?? "",
            "userId": dict["userId"] ?? "",
            "toUserId": dict["toUserId"] ?? ""
        ]

        // Full payload for the plugin
        let callData: [String: Any] = [
            "id": callId,
            "nameCaller": callerName,
            "handle": handle,
            "type": 1, // 1 for video, 0 for audio
            "avatar": profileUrl,
            "duration": 30000,
            "extra": customData,
            "ios": [
                "handleType": "generic"
            ]
        ]
        return callData
    }

    // Schedule local notification to return to call
//     private func scheduleReturnToCallNotification(callData: [String: Any]) {
//         let content = UNMutableNotificationContent()
//         content.title = "Return to Call"
//         content.body = "Tap to return to your ongoing call"
//         content.sound = UNNotificationSound.default
//         content.categoryIdentifier = "RETURN_TO_CALL"
//
//         // Store call data in notification
//         if let callDataJSON = try? JSONSerialization.data(withJSONObject: callData) {
//             content.userInfo = ["call_data": callDataJSON]
//         }
//
//         // Trigger immediately
//         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//
//         let request = UNNotificationRequest(
//             identifier: "return_to_call_\(UUID().uuidString)",
//             content: content,
//             trigger: trigger
//         )
//
//         UNUserNotificationCenter.current().add(request) { error in
//             if let error = error {
//                 NSLog("Failed to schedule return to call notification: \(error)")
//             } else {
//                 NSLog("Return to call notification scheduled")
//             }
//         }
//     }
}

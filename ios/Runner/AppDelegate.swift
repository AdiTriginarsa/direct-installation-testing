import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let esimChannel = FlutterMethodChannel(name: "samples.flutter.dev/esim", binaryMessenger: controller.binaryMessenger)

    esimChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: FlutterResult) in
      result(FlutterMethodNotImplemented)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

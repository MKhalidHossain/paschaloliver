import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBuJYjc5adcBQH3D3WaLQaHjuHmF7LG_Nw")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

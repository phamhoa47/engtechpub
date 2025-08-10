import UIKit
import Flutter
import FirebaseCore // ✅ Khởi tạo Firebase
import flutter_local_notifications // ✅ Plugin local notifications
import UserNotifications // ✅ Dùng để gán delegate cho UNUserNotificationCenter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Cấu hình Firebase
    FirebaseApp.configure()

    // ✅ Đăng ký plugin khi chạy ở isolate background
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // ✅ Gán delegate cho thông báo (iOS 10+)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // ✅ Đăng ký plugin Flutter như bình thường
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

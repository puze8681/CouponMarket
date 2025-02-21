import 'package:coupon_market/manager/firestore_manager.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

PushService pushManager = PushManager();
abstract class PushService {
  Future<void> init();
  Future<void> notify();
  Future<void> dispose();
}

class PushManager extends PushService {
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  PushManager();

  @override
  Future<void> init()async {
    await permissionWithNotification();
    AndroidInitializationSettings android =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
    InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  Future<void> permissionWithNotification() async {
    if (await Permission.notification.isDenied && !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  @override
  Future<void> notify()async {
    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "1",
        "test",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _local.show(1, "Test Success", "Please check the test result!", details);
    fireStoreManager.postNotification(NotificationData(text: "Please check the test result!", isRead: false, createdAt: DateTime.now()));
  }

  @override
  Future<void> dispose()async {

  }
}
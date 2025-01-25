// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotiService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   bool _isInitialized = false;

//   bool get isInitialized => _isInitialized;

//   // INITIALIZE
//   Future<void> initNotification() async {
//     if (_isInitialized) return; // Prevent reinitialization

//     // Prepare android init settings
//     const initSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Prepare ios init settings
//     const initSettingIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     // Init settings
//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingIOS,
//     );

//     // Initialize the plugin
//     await notificationsPlugin.initialize(initSettings);
//     _isInitialized = true;
//   }

//   // NOTIFICATIONS DETAIL SETUP
//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'daily_channel_id',
//         'Daily Notifications',
//         channelDescription: 'Daily Notification Channel',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   // SHOW NOTIFICATION
//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async {
//     return notificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails(),
//     );
//   }
// }

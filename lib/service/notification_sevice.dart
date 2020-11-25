import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  static final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  static final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  static bool grantedPermissons = false;

  static const MethodChannel platform =
      MethodChannel('dexterx.dev/flutter_local_notifications_example');
  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> sendNotification(
      ReceivedNotification notification) async {
    if (Platform.isLinux) {
      final process = Process.run('notify-send',
          ['-a', '"${notification.title}"', '"${notification.body}"']);
      final proccesResult = await process;
      print('Notification: ${proccesResult.stdout}');
    } else {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false);
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, notification.title, notification.body, platformChannelSpecifics,
          payload: notification.payload);
    }
  }

  static Future<NotificationAppLaunchDetails> init() async {
    // needed if you intend to initialize in the `main` function
    WidgetsFlutterBinding.ensureInitialized();
    if (platform.name == 'linux' || platform.name == 'windows') {
      await _configureLocalTimeZone();
    }

    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });

    return notificationAppLaunchDetails;
  }
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

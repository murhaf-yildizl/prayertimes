import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/view/show_prayer_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      "notification",
    );
    var initializationIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIOS);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("----->>>>>>>>>>>>>>>>>>>--==== ${response.id}");
        Get.to(CurrentPrayer());
      },
    );
  }

  cancelNotifications({int id = -1}) {
    if (id == -1)
      _notificationsPlugin.cancelAll();
    else
      _notificationsPlugin.cancel(id);
  }

  Future _notificationDetails(int id) async {
    String azan = pref.getString("azan") ?? "azan4";

    return NotificationDetails(
      android: AndroidNotificationDetails(
        id.toString(),
        "channel_$id",
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(azan),
        playSound: true,
        enableLights: true,
        priority: Priority.high,
        enableVibration: true,

      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future createNotification(
      {required int id,
      required String title,
      required String body,
      required int hour,
      required int minites,
      required int zoneOffset}) async {
    await initNotification();
    tzdata.initializeTimeZones();

    return await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payload: body,
      await _schedual(hour, minites, zoneOffset).then((value) => value),
      await _notificationDetails(id).then((value) => value),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _schedual(int h, int m, int zoneOffset) async {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var offset = now.hour - DateTime.now().hour;
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m, 0, 0, 0)
            .add(Duration(hours: offset));
    //Get.defaultDialog(content: Text("now ${now.hour}:${now.minute} \n offset ${zoneOffset} \n schedual:${scheduledDate.hour}:${scheduledDate.minute}"));
    print("OFFSET$zoneOffset dif=${offset}");
    print("shedual ${now.hour}:${now.minute}");
    print("shedual ${scheduledDate.hour}:${scheduledDate.minute}");

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));

      print("<<<<<<<<<>>>>>>>>>>>::");
    }

    return scheduledDate;
  }
}

import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prayertimes1/view/show_prayer_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../model/prayer.dart';

class NotificationService {
    late String azan;
    late tz.TZDateTime now;
    var offset;
    late FlutterLocalNotificationsPlugin _notificationsPlugin;
     List<AndroidNotificationDetails> notificationsList=[];


  Future<void> initNotification() async {
    tzdata.initializeTimeZones();
    this.azan = azanName.get("azan") ?? "azan4";
    this.now = tz.TZDateTime.now(tz.local);
    this.offset = this.now.hour-DateTime.now().hour;
    this. _notificationsPlugin =FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid =const AndroidInitializationSettings("notification",);
    var initializationIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int? id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIOS);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if(response!=null)
        {
           cancelNotifications(id:response.id!);
           Get.to(CurrentPrayer());
        }
      },
    );
  }

  Future cancelNotifications({int id = -1})async {

    if (id == -1) {
     await _notificationsPlugin.cancelAll();
     }

    else {
     await _notificationsPlugin.cancel(id);
     }


   }


   Future<String?> all()async
   {
     String txt="";
     await _notificationsPlugin.pendingNotificationRequests().then((list){

       if(list!=null) {
         list.forEach((notify) {
           txt+="${notify.id} ${notify.title} ${notify.payload} \n ";
           // print("\n +++++++++++${notify.id} ${notify.title} ${notify.payload} +++++++++\n");
         });

       }
     });
     return txt;
   }

    Future reactiveNotifyByName(String title,int index)async
    {
      late String? date;
      late List<String>? prayerList;
      late PrayerModel? prayer;
      int fixedIndex=index;
      int days=0;

       if (index > 1)
         index--;

         // ignore: curly_braces_in_flow_control_structures
        for(int i=index;i<500;i+=5)
          {
            date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days:days++)));
            prayerList = data.get(date);


            if(prayerList!=null ) {
              final map = jsonDecode(prayerList[fixedIndex]);
              prayer = PrayerModel.fromJson(map);

                if(!prayer.time!.isBefore(now)) {

                  createNotification(
                  prayer.time!,
                  id: i,
                  title:"تنبيه االصلاة",
                  payload: prayer.name.toString(),
                  body: "${prayer.name} صلاة",
                  hour:   prayer.time!.hour,
                  minites:prayer.time!.minute,
                  );
                }
            }
        }

    }


    Future deactiveNotifyByName(String title)async
   {
      await _notificationsPlugin.pendingNotificationRequests().then((list){

       if(list!=null) {
         list.forEach((notify) async {
           if(notify.payload==title) {
             await cancelNotifications(id: notify.id);
              print("ID $title ${notify.id}");

            }
          });
       }
     });
   }
  Future _notificationDetails(int id) async {

    return NotificationDetails(
      android: AndroidNotificationDetails(
        id.toString(),
        "channel_$id",
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(id>-1?azan:""),
        playSound: true,
        enableLights: true,
        priority: Priority.high,
        enableVibration: true,

      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future createNotification(DateTime date,
      {required int id,
      required String title,
      required String body,
      required String payload,
      required int hour,
      required int minites,
      }) async {

    return await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payload: payload,
      await _schedual(id,hour, minites,date,payload).then((value) => value),
      await _notificationDetails(id).then((value) => value),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<tz.TZDateTime> _schedual(int id,int h, int m, DateTime date,String title) async {

    tz.TZDateTime scheduledDate =
         tz.TZDateTime(tz.local,date.year,date.month,date.day , h, m, 0, 0, 0)
            .add(Duration(hours:offset));
     // //Get.defaultDialog(content: Text("now ${now.hour}:${now.minute} \n offset ${zoneOffset} \n schedual:${scheduledDate.hour}:${scheduledDate.minute}"));
    //print("OFFSET$zoneOffset dif=${offset}");
    //print("$id shedual ${h}:${m}");
    print("${date.toString()} ###########################");

    //print("$id shedual ${now.hour}:${now.minute}");

    //print("id=$id $title ${scheduledDate.hour}:${scheduledDate.minute}");

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 100));

      print("<<<<%%%%%%%%%%%%%%%%%%%%%<<<<<>>>>>>>>>>>::");
    }

    return scheduledDate;
  }
}

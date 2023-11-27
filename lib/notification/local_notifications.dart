import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/main.dart';
import 'package:prayertimes1/view/show_prayer_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';


class NotificationService{



 final FlutterLocalNotificationsPlugin  _notificationsPlugin=FlutterLocalNotificationsPlugin();

  Future<void> _initNotification()async
  {

     AndroidInitializationSettings initializationSettingsAndroid=AndroidInitializationSettings("notification");
    var initializationIOS=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:(int? id,String? title,String? body,String? payload )async{

      },
    );

    var initializationSettings=InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationIOS
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
       onDidReceiveNotificationResponse: (NotificationResponse response){
                   print("-------==== ${response.id}");
                   Get.to(CurrentPrayer());

       },
    );


  }

  cancelNotifications({int id=-1})
{


  if(id==-1)
       _notificationsPlugin.cancelAll();
 else  _notificationsPlugin.cancel(id);

  print("ID=$id");
  print(">>>>>>>>>> ${_notificationsPlugin.pendingNotificationRequests().then((value){value.forEach((element) { print("${element.id} ${element.title}");});})}>>>>>>>>>>>>");

}


   Future _notificationDetails(int id)async
  {
   return NotificationDetails(

      android:AndroidNotificationDetails(
         id.toString(),
        "channel_$id",
        importance: Importance.high,
        sound:RawResourceAndroidNotificationSound('azan1') ,
        playSound: true,
        enableLights: true,
        priority: Priority.high,



      ),
     iOS: DarwinNotificationDetails(),




    );

  }

  Future createNotification({required int id,required String title,required String body,required int hour,required int minites,required int zoneOffset})async
  {

    await this._initNotification();
    tzdata.initializeTimeZones();

    return  await _notificationsPlugin.zonedSchedule(
           id,
           title,
           body,
           payload:body,
           await _schedual(hour, minites,zoneOffset),
           await _notificationDetails(id).then((value) =>value),
           uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
           androidAllowWhileIdle: true,
           );


   }





   Future< tz.TZDateTime> _schedual(int h,int m, int zoneOffset)async {

       tz.TZDateTime now = tz.TZDateTime.now(tz.local);
       tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,h,m,0,0,0).add(Duration(hours: -3));
       print("OFFSET$zoneOffset");
print("shedual ${now.hour}:${now.minute}");
print("shedual ${scheduledDate.hour}:${scheduledDate.minute}");

      if (scheduledDate.isBefore(now)) {
         scheduledDate = scheduledDate.add(const Duration(days: 1));
          }

       return scheduledDate;
    }


}
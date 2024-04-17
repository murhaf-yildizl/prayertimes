//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:prayertimes1/view/home.dart';
//
// class AwesoneNotify{
//
//
// Future initializteNotifications()async
// {
//   await AwesomeNotifications().initialize(
//       "resource://drawable/notification",
//       [
//         NotificationChannel(
//             channelKey: "key1",
//             channelName: "channel1",
//             channelDescription: "AAAAAAAAAa",
//             playSound: true,
//             soundSource: "resource://raw/azan1",
//             importance: NotificationImportance.High,
//            defaultColor: Colors.orange,
//            ledColor:Colors.indigo ,
//           channelShowBadge: true,
//
//
//
//         )
//       ]
//   );
//
//   AwesomeNotifications().setListeners(
//       onActionReceivedMethod:(ReceivedNotification r)        {return NotificationController.onAction(r);},
//       onDismissActionReceivedMethod:(ReceivedNotification r) {return NotificationController.onDismiss(r);} ,
//       onNotificationCreatedMethod: (ReceivedNotification r)  {return NotificationController.onCreate(r);},
//       onNotificationDisplayedMethod:(ReceivedNotification r) {return NotificationController.onDisplay(r);}
//   );
//
// }
//
// Future schedualNotifications({required int hour,required int minute})async
// {
//   final DateTime now =DateTime.now();
//   final DateTime schedualTime=DateTime(now.year,now.month,now.day,hour,minute);
//
//   Get.showSnackbar(GetSnackBar(title: 'alert',message: '"befoore ${now.hour}  : ${now.minute} \n after ${schedualTime.hour}: ${schedualTime.minute} "',)).show();
//
//   if(schedualTime.isBefore(now))
//   {
//
//     schedualTime.add(Duration(days: 1));
//     print("HHHHHHHHHHHHh");
//   }
//
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//         id: 1,
//         channelKey: "key1",
//         title: "TTTTTTTTTt",
//       body: "RRRRRRRRRRR",
//       displayOnBackground: true,
//     ),
//     schedule: NotificationCalendar(
//       weekday: schedualTime.weekday,
//       hour: hour,
//       minute: minute,
//       second: 0,
//       allowWhileIdle: true,
//
//     )
//   ) ;
// }
//
// }
//
//
// class NotificationController
// {
//
//  static Future onCreate(ReceivedNotification receivedNotification)async
//   {
//     print("100 -------- ${receivedNotification.body}");
//   }
//
//
//   static Future onDisplay(ReceivedNotification receivedNotification)async
//   {
//     print("200 -------- ${receivedNotification.body}");
//   }
//
//   static Future onDismiss(ReceivedNotification receivedNotification)async
//   {
//     print("300 -------- ${receivedNotification.body}");
//   }
//
//   static Future onAction(ReceivedNotification receivedNotification)async
//   {
//     print("400 -------- ${receivedNotification.body}");
//     Get.to(Home());
//   }
//
// }
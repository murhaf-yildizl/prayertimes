import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/zone-controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/model/zone.dart';
import 'package:prayertimes1/utilities/prayer_settings.dart';

import '../notification/local_notifications.dart';

class PrayerController extends GetxController
{

    List<PrayerModel> prayer_times=[];
    CurrentZone? _zone;

  Future getPrayerTimes()async
  {
     prayer_times=[];
    //41.0782681, 28.9851857
    if(_zone!=null) {
      final params = method.getParameters();
      params.madhab = madhab;

      final allPrayerTimes = PrayerTimes.today(
          Coordinates(_zone!.position.latitude+0.0000001, _zone!.position.longitude+0.0000001) //41.0782681, 28.9851857),
           ,params
      );

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "الفجر",
          time: allPrayerTimes.fajr
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "الشروق",
          time: allPrayerTimes.sunrise
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "الظهر",
          time: allPrayerTimes.dhuhr
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "العصر",
          time: allPrayerTimes.asr
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "المغرب",
          time: allPrayerTimes.maghrib
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: "العشاء",
          time: allPrayerTimes.isha
      ));

      int index=0;
       prayer_times.forEach((pr) {

         if(index!=1)
             NotificationService().createNotification(id:index,title: "تنبيه االصلاة",body: "${pr.name} صلاة",hour: pr.time.hour, minites: pr.time.minute,zoneOffset:_zone!.timeZoneOffset.inHours );

         index++;
       });

      //NotificationService().createNotification(id:100,title:"100 title",body:"100 body",hour:15, minites: 39,zoneOffset: 3);
      //NotificationService().createNotification(id:200,title:"200 title",body:"200 body",hour: 12,minites: 52,zoneOffset: 3);
      //NotificationService().createNotification(id:300,title:"300 title",body:"300 body",hour:12,minites:53,zoneOffset: 3);



    }
    //update();

    //return times;
  }


    @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

      _zone=await ZoneController().initiateZone();

       if(_zone!=null)
       {
         await getPrayerTimes();

       }

      update();
    }

    }

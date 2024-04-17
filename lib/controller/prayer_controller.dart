import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/zone-controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/model/zone.dart';
import 'package:prayertimes1/utilities/prayer_settings.dart';
import '../main.dart';
import '../notification/local_notifications.dart';

class PrayerController extends GetxController
{

    List<PrayerModel> prayer_times=[];
    CurrentZone? _zone;

  Future getPrayerTimes()async
  {
    //41.0782681, 28.9851857

     if(_zone!=null) {

       CalculationMethod params = CalculationMethod.turkey;
       params.getParameters().madhab=Madhab.shafi;

       final allPrayerTimes =  PrayerTimes.today(
          Coordinates(_zone!.position!.latitude,_zone!.position!.longitude),
       //    DateTime.now(),
           params.getParameters(),
           //CalculationMethod.Turkey(),
      );
       //Get.snackbar("titlefffffff"," ${allPrayerTimes.fajr!.hour}").show();

       prayer_times=[];

       prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: prayer_names[0],
          time: allPrayerTimes.fajr
      ));


      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name:prayer_names[1],
          time: allPrayerTimes.sunrise
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: prayer_names[2],
          time: allPrayerTimes.dhuhr
      ));
//////////////////////////
      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: prayer_names[3],
          time: allPrayerTimes.asr
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: prayer_names[4],
          time: allPrayerTimes.maghrib
      ));

      prayer_times.add(PrayerModel
        (
          zone: _zone!,
          name: prayer_names[5],
          time: allPrayerTimes.isha
      ));
       //Get.snackbar("nnnnnn"," ${prayer_times.length}").show();


      int index=0;
       NotificationService().cancelNotifications();

       // prayer_times.forEach((pr) {
       //
       //   pref.setString(pr.name!,jsonEncode(pr.toJson()));
       //
       //   if(index!=1)
       //    {
       //     bool? notify= pref.getBool("${pr.name!}_notify");
       //
       //     if(notify==null)
       //       pref.setBool("${pr.name!}_notify", true);
       //
       //     NotificationService().createNotification(id:index,title: "تنبيه االصلاة",body: "${pr.name} صلاة",hour: pr.time!.hour, minites: pr.time!.minute,zoneOffset:_zone!.timeZoneOffset!.inHours );
       //
       //
       //     }
       //
       //   index++;
       // });

       print("MMMMMMMMMMMMMMMMMMMMMMMMMMMM");
         //NotificationService().cancelNotifications();
       NotificationService().createNotification(id:99,title:"99 title",body:"1009 body",hour:0, minites: 25,zoneOffset: _zone!.timeZoneOffset!.inHours);
       print("MMMMMMMMMMMMMMMMMMMMMMMMMMMM");

       NotificationService().createNotification(id:88,title:"88 title",body:"2007 body",hour: 0,minites:  30,zoneOffset: _zone!.timeZoneOffset!.inHours);
      // NotificationService().createNotification(id:73,title:"300 title",body:"300 body",hour:22,minites:22,zoneOffset: _zone!.timeZoneOffset!.inHours);
       print("MMMMMMMMMMMMMMMMMMMMMMMMMMMM");



    }

    update();


  }


    @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    await initilization();
    update();

    }


    getLocalPrayerTimes()
    {
      prayer_names.forEach((name) {
        final pr_name=pref.getString(name)??null;

        if(pr_name!=null) {
          final map = jsonDecode(pr_name);
          final pp = PrayerModel.fromJson(map);
          prayer_times.add(pp);
        }

      });



    }

  Future initilization()async {
    getLocalPrayerTimes();

    _zone=await ZoneController().initiateZone();

    if(_zone!=null)
    {
      await getPrayerTimes();

    }



  }

    @override
    void dispose() {

    }


}

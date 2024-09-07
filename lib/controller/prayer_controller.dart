import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prayertimes1/controller/zone-controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/model/zone.dart';
import 'package:prayertimes1/utilities/prayer_settings.dart';
import '../main.dart';
import '../notification/local_notifications.dart';

class PrayerController extends GetxController {
  List<PrayerModel> prayer_times = [];
  List<PrayerModel> today_prayer_times = [];
  CurrentZone? _zone;
  late DateTime now;
  late DateTime date;
  late int currentYear;
  late int savedYear;


  @override
  Future<void> onInit() async {
    super.onInit();
    //pref = await SharedPreferences.getInstance();
    await initialization();
    update();
  }

  Future getPrayerTimes() async {
    now = DateTime.now();
    date = now;
    currentYear = now.year;
    savedYear = data.get("year") ?? -1;


    if (_zone != null && currentYear > savedYear) {
      data.put("year", currentYear);

      CalculationMethod params = CalculationMethod.turkey;
      params.getParameters().madhab = Madhab.shafi;


       await calculateTimes(daysCount: 90, params: params);

      update();
    }

   }


Future  getLocalPrayerTimes()async {

    prayer_times = [];
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<String>? prayerList = data.get(today);

     if (prayerList != null) {
      prayerList.forEach((pray) {
        final map = jsonDecode(pray);
        final pp = PrayerModel.fromJson(map);
        prayer_times.add(pp);
       });

      today_prayer_times = prayer_times;
     }

   }

  Future initialization() async {

    await getLocalPrayerTimes();

    _zone = await ZoneController().initiateZone();

    if (_zone != null) {
      data.put("zone", _zone!.placemark!.administrativeArea!);

      if (today_prayer_times.isNotEmpty) {
        if (today_prayer_times.first.zone?.placemark?.administrativeArea !=
            _zone?.placemark?.administrativeArea) {
           data.clear();
        }
      }

      await getPrayerTimes();
    }

    update();
  }

  @override
  void dispose() {}

  Future calculateTimes({required int daysCount, required CalculationMethod params}) async {
    NotificationService notificationService=NotificationService();

    await notificationService.initNotification();
    await notificationService.cancelNotifications();

     int notify_id=0;

    //(41.015137,28.979530),
    //print(")))))))  ${_zone!.timeZoneOffset!.inHours} ${_zone!.timeZoneOffset!.inMinutes} ))))))");
    for (int days = 0; days < daysCount; days++) {
      date = now.add(Duration(days: days));
       final allPrayerTimes = PrayerTimes.utc(
          Coordinates(_zone!.position!.latitude, _zone!.position!.longitude),
          DateComponents.from(date),
          params.getParameters(),
          //Duration(hours: now.timeZoneOffset.inHours)
      );


      prayer_times = [];

       prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[0] , time: allPrayerTimes.fajr.toLocal()));

      prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[1], time: allPrayerTimes.sunrise.toLocal()));

      prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[2], time: allPrayerTimes.dhuhr.toLocal()));
      prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[3], time: allPrayerTimes.asr.toLocal()));

      prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[4], time: allPrayerTimes.maghrib.toLocal()));

      prayer_times.add(PrayerModel(
          zone: _zone!, name: prayer_names[5], time: allPrayerTimes.isha.toLocal()));

      if (days == 0)
        {today_prayer_times = prayer_times;update();}

      int index = 0;
      List<String> prayers = [];

      prayer_times.forEach((pr) {

        prayers.add(jsonEncode(pr.toJson()));

        if (index != 1) {
           bool? prayer_notify = notify.get("${pr.name!}_notify");

          if (prayer_notify == null)
            {
              notify.put("${pr.name!}_notify", true);
              prayer_notify=true;

            }

          if(prayer_notify && !pr.time!.isBefore(now)) {
            notificationService.createNotification(
              date,
              id: notify_id++,
              title:"تنبيه االصلاة",
              payload: pr.name.toString(),
              body: "${pr.name} صلاة",
              hour:   pr.time!.hour,
              minites:pr.time!.minute,
           );

            prayer_notify=false;
          }

        }

        index++;
      });

      data.put(DateFormat('yyyy-MM-dd').format(date), prayers);
    }
  }

 }
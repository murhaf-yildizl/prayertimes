

import 'package:adhan/adhan.dart';
import 'package:prayertimes1/model/zone.dart';

import '../utilities/prayer_settings.dart';

class PrayerModel{
   CurrentZone zone;
   String name;
   DateTime time;

   PrayerModel({required this.zone,required this.name,required this.time});
}
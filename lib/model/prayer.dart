import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:prayertimes1/model/zone.dart';
import '../utilities/prayer_settings.dart';

class PrayerModel{
    CurrentZone? zone;
    String? name;
    DateTime? time;

   PrayerModel({required this.zone,required this.name,required this.time});

   PrayerModel.fromJson(Map<String,dynamic>map){
      this.zone=CurrentZone.fromJson(jsonDecode(map['zone']));
      this.name=map['name'];
      this.time=DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(map['time']);

   }

     Map<String,dynamic> toJson( )
   {
      return {

         'zone':jsonEncode(CurrentZone.toJson(this.zone!)),
         'name': this.name,
         'time':this.time.toString()
      };
   }
}
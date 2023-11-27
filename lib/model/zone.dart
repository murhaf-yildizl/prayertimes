import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class CurrentZone{

  Position position;
  Placemark placemark;
  Duration timeZoneOffset;
  DateTime currenttTime;

  CurrentZone({required this.position,required this.placemark,required this.timeZoneOffset,required this.currenttTime});
}
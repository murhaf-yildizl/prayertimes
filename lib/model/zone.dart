import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';

class CurrentZone {
  Position? position;
  Placemark? placemark;
  Duration? timeZoneOffset;
  DateTime? currentTime;

  CurrentZone(
      {required this.position,
      required this.placemark,
      required this.timeZoneOffset,
      required this.currentTime});

  CurrentZone.fromJson(Map<String, dynamic> map) {
    this.position = Position.fromMap(map['position']);
    this.placemark = Placemark.fromMap(map['placemark']);
    this.timeZoneOffset = parseTime(map['timeZoneOffset']);
    this.currentTime =
        DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(map['currentTime']);
  }

  static Map<String, dynamic> toJson(CurrentZone zone) {
    Position p = Position(
        longitude: zone.position!.longitude,
        latitude: zone.position!.latitude,
        accuracy: zone.position!.accuracy,
        altitude: zone.position!.altitude,
        altitudeAccuracy: zone.position!.altitudeAccuracy,
        heading: zone.position!.heading,
        headingAccuracy: zone.position!.headingAccuracy,
        speed: zone.position!.speed,
        speedAccuracy: zone.position!.speedAccuracy,
        timestamp: zone.position!.timestamp);

    return {
      'position': p.toJson(),
      'placemark': zone.placemark!.toJson(),
      'timeZoneOffset': zone.timeZoneOffset.toString(),
      'currentTime': zone.currentTime.toString(),
    };
  }
}

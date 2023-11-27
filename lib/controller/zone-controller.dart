import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/zone.dart';
import 'package:timezone/timezone.dart' as tz;

class ZoneController {
   CurrentZone? zone;

 Future<CurrentZone?> initiateZone()async
  {
    Position? _location=await getCurrentLocation();

    if(_location!=null)
    {
print("%%%%%%%%%% ${_location.longitude}  ${_location.latitude}");
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _location.latitude,
          _location.longitude
      );

      if(placemarks.length>0)
        {
          final placemark=placemarks.first;
          final timeZoneOffset=DateTime.now().timeZoneOffset.inHours;
              print("ZONE ${DateTime.now().timeZoneOffset.inMinutes}");
          zone=CurrentZone(position: _location, placemark: placemark, timeZoneOffset: Duration(minutes:timeZoneOffset),currenttTime:DateTime.now());

        }

    }
    return zone;



  }

  Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission;

      permission = await Geolocator.requestPermission();

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


    } catch (e) {
      print("Error: $e");
    }



}

}
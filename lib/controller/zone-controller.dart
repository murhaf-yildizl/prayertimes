import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../model/zone.dart';

class ZoneController {
   CurrentZone? zone;

 Future<CurrentZone?> initiateZone()async
  {

    Position? _location=await getCurrentLocation();
     if(_location!=null)
    {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _location.latitude,
          _location.longitude
      );

      if(placemarks.length>0)
        {


          final placemark=placemarks.first;

          final timeZoneOffset=DateTime.now().timeZoneOffset.inHours;
          zone=CurrentZone(position: _location, placemark: placemark, timeZoneOffset: Duration(minutes:timeZoneOffset),currentTime:DateTime.now());

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
      Get.snackbar("error", e.toString());
      print("Error: $e");
    }



}

}
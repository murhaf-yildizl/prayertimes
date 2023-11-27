import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/utilities/image_urls.dart';

class PrayerTime extends StatefulWidget {
  @override
  _PrayerTimeState createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {

  String selectedPrayerTime = 'Fajr'; // Default selected prayer time
  int currentPageIndex = 0; // Current page index
  int h=-1;

   PageController pageController=PageController(
     initialPage: 0,
     viewportFraction: 0.3,
   );
@override
  void initState() {
    // TODO: implement initState

  super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:GetBuilder<PrayerController>(
          builder: (controller)
          {
            if(controller.prayer_times.isNotEmpty) {

                 return  drawConents(controller.prayer_times);

            }

            return const Center(child: CircularProgressIndicator());

          },
        ),

    );
  }

  Widget drawConents(List<PrayerModel> prayer_times) {
             return Stack(
               children: [
                 Container(
                     height: double.infinity,
                     width: double.infinity,
                     child: Image.asset(urls[6],fit: BoxFit.cover,)),
                 // Container(
                 //   width: double.infinity,
                 //   height: double.infinity,
                 //   decoration: BoxDecoration(
                 //       gradient: LinearGradient(
                 //           begin: Alignment.topCenter,
                 //           end: Alignment.bottomCenter,
                 //           colors: [
                 //             Colors.transparent,
                 //             Colors.white
                 //           ]
                 //       )
                 //   ),
                 //   child:   Container(
                 //     width: double.infinity,
                 //     height: double.infinity,
                 //     decoration: BoxDecoration(
                 //         gradient: LinearGradient(
                 //             begin: Alignment.topCenter,
                 //             end: Alignment.bottomCenter,
                 //             colors: [
                 //               Colors.transparent,
                 //               Colors.white
                 //             ]
                 //         )
                 //     ),
                 //   )
                 //   ,
                 // ),
                 Container(
                 padding: const EdgeInsets.symmetric(vertical: 8,horizontal:8),
                 child: ListView(
                   shrinkWrap: true,
                   children: [
                     const SizedBox(height: 30,),
                     drawLocation(prayer_times.first.zone.placemark),
                     SizedBox(height: 150,),
                     drawTimes(prayer_times)
    ],
                 ),

           ),
               ],
             );

}


  Widget drawLocation(Placemark place) {
  return  Center(
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(

          style: TextStyle(color: Colors.white,fontFamily: 'lateef',fontWeight: FontWeight.bold,fontSize: 32,letterSpacing: 2,height:1.5),
          children:
          [
            TextSpan(text:"${place.country}"),
            TextSpan(text: "\n"),
            TextSpan(text:"${place.administrativeArea}")
          ]
      ),

    ),
  );
    return  Center(child: Text("${place.country}\n${place.administrativeArea}",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,fontFamily: 'lateef',color: Colors.white,letterSpacing: 3),));

  }

  Widget  drawTimes(List<PrayerModel> prayer_times) {
    return  SizedBox(
        height: Get.height*0.90,
        child: PageView.builder(
          padEnds: false,
            scrollDirection: Axis.vertical,
            controller: pageController,
            itemBuilder: (context, i) {

              if(prayer_times.isNotEmpty)
                return drawPages(i,prayer_times);

              return Text('');
            },
            onPageChanged: (int page) {
              setState(() {
                currentPageIndex = page;
              });
            }
        )
    );
  }

Widget drawPages(int i, List<PrayerModel> prayer_times) {

    if(h>=prayer_times.length)
       h=-1;

    h++;

  return Container(

    child: Directionality(

      textDirection:i!=currentPageIndex?TextDirection.rtl:TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          i==currentPageIndex?
         drawPrayerImage(i,prayer_times):Text(''),
         drawPrayerName(i,prayer_times),

        ],
      ),
    ),
  );

  }

  Widget drawPrayerImage(int i, List<PrayerModel> prayer_times) {
    return AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular( 100.0),
          child: Image.asset(
            urls[i% prayer_times.length], // Replace with your image URL
            fit: BoxFit.cover,
          ),
        )
    );
  }

 Widget drawPrayerName(int i, List<PrayerModel> prayer_times) {
  return  Padding(
      padding: const EdgeInsets.all(10),
      child: i==currentPageIndex?
      Container(
        width: 150,
        height: 120,
        color:Colors.transparent,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(

                style: TextStyle(color: Colors.white,fontFamily: 'lateef',fontWeight: FontWeight.bold,fontSize: 32,letterSpacing: 2,height:1.5),
                children:
                [
                  TextSpan(text:"${prayer_times[i%prayer_times.length].name}"),
                  TextSpan(text: "\n"),
                  TextSpan(text:"${prayer_times[i% prayer_times.length].time.hour}:"
                      "${prayer_times[i% prayer_times.length].time.minute}" )
                ]
            ),

          ),
        ),
      ):
      Container(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(

              style: TextStyle(color: Colors.white,fontFamily: 'lateef',fontWeight: FontWeight.normal,fontSize: 24,letterSpacing: 2,height:1),
              children:
          [
            TextSpan(text:"${prayer_times[i% prayer_times.length].name}"),
            TextSpan(text:" ${prayer_times[i% prayer_times.length].time.hour}:"
                "${prayer_times[i% prayer_times.length].time.minute}" )
          ]
          ),

        ),
      )


  );
 }


}

import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/image_urls.dart';

class PrayerTime extends StatefulWidget {
  @override
  _PrayerTimeState createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  String selectedPrayerTime = 'Fajr'; // Default selected prayer time
  int currentPageIndex = 0; // Current page index
  //int h=-1;

  PageController pageController = PageController(
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
      body: GetBuilder<PrayerController>(
        builder: (controller) {
          if (controller.prayer_times.isNotEmpty) {
            return drawConents(controller.prayer_times);
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
            child: Image.asset(
              urls[6],
              fit: BoxFit.cover,
            )),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //const SizedBox(height: 10,),
                drawLocation(prayer_times.first.zone!.placemark!),
                //SizedBox(height: 50,),
                drawTimes(prayer_times)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawLocation(Placemark place) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'lateef',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                letterSpacing: 2,
                height: 1.5),
            children: [
              TextSpan(text: "${place.country}"),
              TextSpan(text: "\n"),
              TextSpan(text: "${place.administrativeArea}")
            ]),
      ),
    );
    return Center(
        child: Text(
      "${place.country}\n${place.administrativeArea}",
      style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'lateef',
          color: Colors.white,
          letterSpacing: 3),
    ));
  }

  Widget drawTimes(List<PrayerModel> prayer_times) {
    return SizedBox(
        height: Get.height * 0.90,
        child: PageView.builder(
            padEnds: false,
            scrollDirection: Axis.vertical,
            controller: pageController,
            itemBuilder: (context, i) {
              if (prayer_times.isNotEmpty) return drawPages(i, prayer_times);

              return Text('');
            },
            onPageChanged: (int page) {
              setState(() {
                currentPageIndex = page;
              });
            }));
  }

  Widget drawPages(int i, List<PrayerModel> prayer_times) {
    ;

    return Directionality(
        textDirection:
            i != currentPageIndex ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            // color: Colors.red,

            //height:i!=currentPageIndex?200:1000,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  i == currentPageIndex
                      ? drawPrayerImage(i, prayer_times)
                      : Text(""),
                  Container(
                      height: screen_height * 0.15,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: i == currentPageIndex
                              ? Colors.red.withOpacity(0.3)
                              : Colors.transparent),
                      child: drawPrayerName(i, prayer_times)),
                ]),
          ),
        ));
  }

  Widget drawPrayerImage(int i, List<PrayerModel> prayer_times) {
    return AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        width: screen_width * 0.40,
        height: screen_width * 0.40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 3.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Image.asset(
            urls[i % prayer_times.length], // Replace with your image URL
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget drawPrayerName(int i, List<PrayerModel> prayer_times) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: i == currentPageIndex
            ? Container(
                width: screen_width * 0.40,
                height: screen_height * 0.10,
                color: Colors.transparent,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text:
                                  "${prayer_times[i % prayer_times.length].name}"),
                          TextSpan(text: "\n"),
                          TextSpan(
                              text:
                                  "${prayer_times[i % prayer_times.length].time!.hour}:"
                                  "${prayer_times[i % prayer_times.length].time!.minute.toString().padLeft(2, '0')}")
                        ]),
                  ),
                ),
              )
            : Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                            text:
                                "${prayer_times[i % prayer_times.length].name}"),
                        TextSpan(
                            text:
                                " ${prayer_times[i % prayer_times.length].time!.hour}:"
                                "${prayer_times[i % prayer_times.length].time!.minute.toString().padLeft(2, "0")}")
                      ]),
                ),
              ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/themes.dart';
import 'package:prayertimes1/view/home.dart';
import 'controller/date_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box<dynamic> data;
late Box<bool>   notify;
late Box<String> azanName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  notify   = await Hive.openBox('notify');
  azanName = await Hive.openBox("azan");
  data      = await Hive.openBox("data");

    runApp(MyApp());

}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context)   {


    deviceDemensions(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    Get.put(PrayerController());
    Get.put(DateController());

      int? savedYear=data.get("year");

    Future.delayed(Duration(seconds: savedYear!=null?1:6), ()   {

      runApp(GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.leftToRightWithFade,
          title: '',
          theme: arabicTheme(),
          home: Home()));

    });
    return     splashScreen( );
  }

   splashScreen()    {

   return Container(
      color: Colors.white,
      child: Center(
          child: Lottie.asset(
        "assets/images/lottie1.json",
        height: Get.height * 0.65,
        width: Get.width * 0.65,
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/view/home.dart';
import 'notification/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  pref=await SharedPreferences.getInstance();


  // await AwesoneNotify().initializteNotifications();

  runApp(MyApp( ));
}


class MyApp extends StatelessWidget {

    MyApp( {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

      )
    );

    Get.put(PrayerController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,

      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home()//PrayerTimeDropdown(),
    );
  }
}

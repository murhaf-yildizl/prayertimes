import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/themes.dart';
import 'package:prayertimes1/view/home.dart';
//import 'notification/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity/connectivity.dart';
import 'controller/date_controller.dart';



late SharedPreferences pref;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);

  pref=await SharedPreferences.getInstance();


  runApp(MyApp( ));
}


class MyApp extends StatelessWidget {

    MyApp( {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    deviceDemensions(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

      )
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

     Get.put(PrayerController());
     Get.put(DateController());

     Future.delayed(Duration(seconds: 3),(){
       runApp(GetMaterialApp(

           debugShowCheckedModeBanner: false,
           defaultTransition: Transition.leftToRightWithFade,

           title: 'Flutter Demo',
           theme: arabicTheme(),
           home:Home()
       ));
     });
    return splashScreen();
  }

 Widget splashScreen() {

    // dailyTask();

    return Container(
      color: Colors.white,
      child: Center(child: Lottie.asset("assets/images/lottie1.json",height: Get.height*0.65,width: Get.width*0.65,)),
    );

 }
}




dailyTask()  {

  Workmanager().registerPeriodicTask(
    DateTime.now().toString(),
    "dailytask",
    frequency: Duration(minutes: 1),
    initialDelay: Duration(hours: 6),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask(  (taskName, inputData) async {

    print("................$taskName started.................");
    pref.setBool("daily", true);


     PrayerController().initilization();

    //}
    return Future.value(true);

  }
  );
}

Future<bool> checkConnectivity()async {

  var result=await Connectivity().checkConnectivity();

  print(result.name);
  if(result.name=="none")
    return false;

  return true;

}

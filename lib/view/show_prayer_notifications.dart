import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/controller/prayer_controller.dart';
import 'package:prayertimes1/model/prayer.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/time_utility.dart';
import 'package:prayertimes1/view/home.dart';
import '../main.dart';
import '../notification/local_notifications.dart';

class CurrentPrayer extends StatefulWidget {

  CurrentPrayer();

  @override
  State<CurrentPrayer> createState() => _CurrentPrayerState();
}

class _CurrentPrayerState extends State<CurrentPrayer>  with TickerProviderStateMixin  {
  Map<String,dynamic> remainingTime={};
  late int remainingHours,remainingMinutes,remainingSeconds;
  bool stoped=false,timerFinished=false;
  List<bool> notif_iconColor =[];
  late Timer timer;
  ValueNotifier <String> timerNotifier=ValueNotifier('');
  late AnimationController _controller;
  late AnimationController _rowController;
  late Animation<double> _animation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 20))..repeat(reverse: true);

    notif_iconColor=List.generate(6, (index) => index!=1?true:false);



    _rowController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 3).animate(_rowController);

  }



  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _controller.dispose();
    _rowController.dispose();
    timer.cancel();



  }

  @override
  Widget build(BuildContext context) {

    timer=Timer.periodic(Duration(seconds: 1), (Timer t) {
      startCounter(t);
    });

     return Scaffold(
          body: GetBuilder<PrayerController>(
            init: PrayerController(),
            builder:(prayerController)
            {
             if(prayerController.prayer_times.isNotEmpty) {

                getRemainingTime(prayerController.prayer_times);

               return  timerFinished && stoped==false?
                              showCurrentTime():drawTimes(prayerController.prayer_times);

             }
              return Text('');
            } ,
          ),

    );

  }


  Widget showCurrentTime()
  {
    return  Center(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/ishaa.png",
                    ),
                    fit: BoxFit.cover
                )),
            child: Center(
                child: SlideTransition(
                    position: Tween<Offset>(
                        begin: Offset(0,-0.4),
                        end: Offset(0,0.4)
                    ).animate(_controller),
                    child: Container(
                      decoration:const  BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/mosque2.jpg"),
                              fit: BoxFit.fill
                          )
                      ),
                      height: 300,
                      width: 300,
                      //  color: Colors.blueAccent,
                      child: Column(
                        children: [
                          SizedBox(height: 60,),
                          Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                              child: Text("  حان الآن وقت صلاة ${remainingTime['name']}",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),)),
                           Spacer(),
                           IconButton(
                               onPressed: (){
                                 setState(() {
                                   stoped=true;
                                 });
                                 Get.to(Home());
                               },
                               icon: Icon(Icons.stop_circle_outlined,size: 50,color: Colors.red,)

                           ),
                            SizedBox(height: 20,),
                        ],
                      ),
                    )
                )
            )
        )
    );
  }

  Widget drawRow(PrayerModel prayer,int index) {

    bool notified=pref.getBool("${prayer.name!}_notify")??false;

     if(notified==true)
        notif_iconColor[index]=true;
  else  notif_iconColor[index]=false;

    return Card(
      color: Colors.grey.shade200,
      margin: EdgeInsets.all(10),
      child: ScaleTransition(
        scale: _rowController,
        child: Container(
          height: screen_height*0.10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
    gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueAccent,
                  Colors.grey
                ]
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           Container(
             width:screen_width*0.20,
             child: Center(
               child: IconButton(
                    onPressed:(){
                       if(index==1)
                         return;

                    setState(() {
                     if(notified==false)
                     {
                       notif_iconColor[index]=true;
                       pref.setBool("${prayer.name!}_notify", true);
                       NotificationService().createNotification(id:index,title: "تنبيه االصلاة",body: "${prayer.name} صلاة",hour: prayer.time!.hour, minites: prayer.time!.minute,zoneOffset: prayer.zone!.timeZoneOffset!.inHours);

                     }
                     else
                     {
                       notif_iconColor[index]=false;
                       pref.setBool("${prayer.name!}_notify", false);
                       NotificationService().cancelNotifications(id:index);

                     }

                   });

                    },
                    icon: Icon(Icons.add_alert,size: icon_size,color:notif_iconColor[index]==true?Colors.orange:Colors.grey,),
                ) ,
             ),
           ),
           Container(
               width:screen_width*0.30,
               child: Center(child: Text("${prayer.time!.hour}:${prayer.time!.minute.toString().padLeft(2,'0')}",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.indigo),)))  ,
           Container(
               width:screen_width*0.40,
               child: Center(child: Text("${prayer.name}",style:Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.indigo),)))

          ],
          ),
        ),
      ),
    );
  }

  Widget drawRemainingTime(List<PrayerModel> prayer_times) {

    return Container(
      height: screen_height*0.20,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(250)
      ),
      child: Card(
             margin:EdgeInsets.symmetric(vertical: 10) ,
            color:Colors.transparent,
            child: Center(
                child: ListenableBuilder(
               listenable: timerNotifier,
               builder:(context,w,){
                 drawText();
                 return   Column(
                   mainAxisAlignment:MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     timerFinished? Text("حان الآن وقت صلاة ${remainingTime['name']}",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold))
                         :remainingTime['index']==1?  Text(": "+" ${remainingTime['name']??''} بعد ",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold))
                         :Text(": "+"صلاة  ${remainingTime['name']??''} بعد ",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold)),

                     SizedBox(height: 10,),

                     timerFinished?Text(''):Text(timerNotifier.value,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.amberAccent,fontWeight: FontWeight.bold)),
                   ],
                 );

               }
                ))
      ),
    );
  }

  drawText() {

 String text="";

 if(remainingHours==0 && remainingMinutes>0)
     text= "${remainingMinutes.toString().padLeft(1,'0')}:${remainingSeconds.toString().padLeft(2,'0')}";

 else  if(remainingHours==0 && remainingMinutes==0)
     text= "${remainingSeconds.toString().padLeft(2,'0')}";

 else text= "${remainingHours}:${remainingMinutes.toString().padLeft(2,'0')}:${remainingSeconds.toString().padLeft(2,'0')}";

 timerNotifier.value=text;


 }

  void getRemainingTime(List<PrayerModel> prayer_times) {
    remainingTime=calculateNearestTime(prayer_times);
    remainingHours=remainingTime['remaininghours'];
    remainingMinutes=remainingTime['remainingminutes'];
    remainingSeconds=remainingTime['remainingsecond'];
  }

  drawTimes(List<PrayerModel> prayer_times) {
    return Container(
        height: Get.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/mosque12.jpg"),
                fit:BoxFit.cover
            )
        ),
        child:  SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //SizedBox(height:screen_height*0.09),

                for(int i=0;i<prayer_times.length+1;i++)
                  i==0? drawRemainingTime(prayer_times): drawRow(prayer_times[i-1],i-1),
                SizedBox(height: screen_height*0.10,)
              ]
          ),
        )

    );
  }

  void startCounter(Timer t) {

          if(remainingSeconds>0)
            remainingSeconds--;

         if(remainingSeconds==0 && remainingMinutes==0 && remainingHours==0)
           {

             setState(() {
               Future.delayed(Duration(minutes: 1),(){
                 setState(() {
                          timerFinished=false;
                          stoped=true;
                          timer=Timer.periodic(Duration(seconds: 1), (Timer t) {
                            startCounter(t);
                          });
                  });
               });
               timer.cancel();
               timerFinished=true;
             });

           }
         else if(remainingSeconds==0)
            {
              remainingSeconds=59;

              if(remainingMinutes>0)
                remainingMinutes--;

              if(remainingMinutes==0 && remainingHours>0)
                {
                  remainingMinutes=59;

                  if(remainingHours>0)
                    remainingHours--;
                }

            }

         drawText();

  }
  }
  
  
  


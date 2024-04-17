import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import '../controller/date_controller.dart';

class ShowDate extends StatefulWidget {
  const ShowDate({super.key});

  @override
  State<ShowDate> createState() => _ShowDateState();
}

class _ShowDateState extends State<ShowDate> {

  DateController dateController=Get.find<DateController>();

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/hijri.png"),
            fit: BoxFit.fill,


            )
        ),
        child: dateController.hijriDate!=null?drawContents():Center(child: CircularProgressIndicator())
    )

    );
  }



  Widget drawContents( ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            drawTitle(),
            SizedBox(height: 10,),
            drawHeader( ),
            SizedBox(height: 10,),
            drawDayName(),
            SizedBox(height: 10,),
            drawGregorian( ),
            SizedBox(height: 20,),
            drawHijri( )
        
          ],
        ),
      ),
    );
  }

 Widget drawHeader( ) {
    int m=dateController.testMonth();

    if(m==1)
      return drawImage("assets/images/ramadan.jpg");
   else if(m==2)
      return drawImage("assets/images/fitir.jpg");
   else if(m==3)
      return drawImage("assets/images/adha.png");

   else
     {
       int days=dateController.dyasToRamadan();

       return drawCard("   بقي لشهر رمضان  ${days} يوم ",0);
     }


  }

 Widget drawGregorian( ) {

    return drawCard("ميلادي:  ${dateController.getGregorianDate()}",1);

  }

Widget  drawHijri( ) {
  return drawCard("هجري:  ${dateController.getHijriDate()}",2);

}

  Widget drawCard(String text, int index)
  {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
           height: screen_height*0.10,
           width:  screen_width*0.80,
          decoration: BoxDecoration(
              color: index==0?Colors.green.withOpacity(0.4):Colors.teal.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),


          ),
          child: Center(child: Text(text,style:Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),))),
    );

  }

 Widget drawImage(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Image.asset(url,fit: BoxFit.fill,height: screen_height*0.30,width: double.infinity,),
    );
 }

  Widget drawDayName() {
   
   return drawCard("اليوم ${dateController.getDayName()}",3);


   
  }

  Widget drawTitle() {
   return Text("الـتـقويــم",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.amber,fontWeight: FontWeight.bold),);
  }
}

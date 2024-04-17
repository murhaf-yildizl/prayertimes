import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/widgets/drawer.dart';
import 'package:prayertimes1/view/compass.dart';
import 'package:prayertimes1/view/home_interface.dart';
import 'package:prayertimes1/view/show_azkar.dart';
import 'package:prayertimes1/view/show_date.dart';
import 'package:prayertimes1/view/show_prayer_times.dart';
import 'show_prayer_notifications.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeInterface{
  late PageController _pageController;
  bool bottomPressed=false;
  int currentPage=0;
  final GlobalKey <ScaffoldState> _key=GlobalKey<ScaffoldState>();
  final GlobalKey <CurvedNavigationBarState> _navigationKey=GlobalKey();
  List<Widget>   _screens=[];
  List<IconData> _icons=[];
  List<String>   _lables=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController=PageController(initialPage: currentPage);
     initilizeItems();
   }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
     key: _key,
     endDrawer: CustomDrawer(),
      body: PageView(
        controller: _pageController,
        children: _screens,

        onPageChanged: (index) {
           if(currentPage==index || !bottomPressed)
           setState(() {
            currentPage=index;
            });
         bottomPressed=false;
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navigationKey,
        index:currentPage ,
        onTap: (index){

             if(index==_screens.length)
             {
                 _key.currentState!.openEndDrawer();
              }

            else {
              setState(() {
              currentPage = index;
              bottomPressed=true;

              _pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
            });
            }

          },
          //height:screen_height*0.20,
          backgroundColor: Colors.transparent,
          color: Color.fromRGBO(1, 110, 110, 0.8),
          items:List.generate(_screens.length+1, (index) =>getItems(index)),

        ),

    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _pageController.dispose();


   }

Widget getItems(int index) {

      bool selected=currentPage==index||index==_screens.length;
      return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: BoxConstraints(
          //minHeight: 200,
           ),
         //height:600, //!selected?250:250,
        //width: 300,// !selected?250:250,
        child: Column(
          mainAxisAlignment: !selected? MainAxisAlignment.end: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Icon(
             _icons[index],
              color: Colors.white,
              size: icon_size,
          ),
            // SizedBox(height: 5),
            //!selected?Expanded(child: Text(_lables[index],style:Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),)):SizedBox(height: 0,),
        ]
        ),
            ),
      );
 }

  void initilizeItems() {
     List<dynamic>items=[];

     items.add(createPage(PrayerTime(), Icons.mosque_outlined,"أوقات الصلاة"));
     items.add(createPage(CurrentPrayer(), Icons.add_alert_sharp, "التنبيهات"));
     items.add(createPage(ShowAzkar(), Icons.note_alt_outlined, "الأذكار"));
     items.add(createPage(Compass(), Icons.compass_calibration_outlined, "البوصلة"));
     items.add(createPage(ShowDate(), Icons.calendar_today, "التاريخ"));
     items.add(createPage(Text(''), Icons.menu, "القائمة"));


    _screens= List.generate(items.length-1, (index) => items[index][0]);
    _icons  = List.generate(items.length, (index) => items[index][1]);
    _lables = List.generate(items.length, (index) => items[index][2]);

  }



  @override
  List<dynamic>createPage(Widget page, IconData iconData, String bottomLable) {
    // TODO: implement createPage
    return [page,iconData,bottomLable];
    throw UnimplementedError();
  }

}


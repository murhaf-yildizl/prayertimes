import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/utilities/widgets/drawer.dart';
import 'package:prayertimes1/view/compass.dart';
import 'package:prayertimes1/view/home_interface.dart';
import 'package:prayertimes1/view/show_azkar.dart';
import 'package:prayertimes1/view/show_date.dart';
import 'package:prayertimes1/view/show_prayer_times.dart';
import 'package:workmanager/workmanager.dart';
import 'show_prayer_notifications.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeInterface {
  late PageController _pageController;
  bool bottomPressed = false;
  int currentPage = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<CurvedNavigationBarState> _navigationKey = GlobalKey();
  List<Widget> _screens = [];
  List<Image> _icons = [];
  List<String> _lables = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    initilizeItems();

    Workmanager().registerPeriodicTask(
      DateTime.now().toString(),
      "dailytask",
      frequency: Duration(hours: 6),
      //initialDelay: Duration(hours: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: CustomDrawer(),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          if (currentPage == index || !bottomPressed)
            setState(() {
              currentPage = index;
            });
          bottomPressed = false;
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _navigationKey,
        index: currentPage,
        onTap: (index) {
          if (index == _screens.length) {
            _key.currentState!.openEndDrawer();
          } else {
            setState(() {
              currentPage = index;
              bottomPressed = true;

              _pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
            });
          }
        },
        //height:screen_height*0.20,
        backgroundColor: Color.fromRGBO(9, 100, 140, 0.4),
        color: Color.fromRGBO(9, 100, 140, 0.4),
        items: List.generate(_screens.length + 1, (index) => getItems(index)),
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
    bool selected = currentPage == index || index == _screens.length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _icons[index],
    );
  }

  void initilizeItems() {
    List<dynamic> items = [];

    items.add(createPage(
        PrayerTime(),
        Image.asset(
          "assets/icons/times.png",
          height: icon_size,
          width: icon_size,
          fit: BoxFit.fill,
        ),
        "أوقات الصلاة"));
    items.add(createPage(
        CurrentPrayer(),
        Image.asset("assets/icons/alarm.png",
            height: icon_size, width: icon_size, fit: BoxFit.fill),
        "التنبيهات"));
    items.add(createPage(
        ShowAzkar(),
        Image.asset("assets/icons/azkar.png",
            height: icon_size, width: icon_size, fit: BoxFit.fill),
        "الأذكار"));
    items.add(createPage(
        Compass(),
        Image.asset("assets/icons/compass.png",
            height: icon_size, width: icon_size, fit: BoxFit.fill),
        "البوصلة"));
    items.add(createPage(
        ShowDate(),
        Image.asset("assets/icons/date.png",
            height: icon_size, width: icon_size, fit: BoxFit.fill),
        "التاريخ"));
    items.add(createPage(
        Text(''),
        Image.asset("assets/icons/menu.png",
            height: icon_size, width: icon_size, fit: BoxFit.fill),
        "القائمة"));

    _screens = List.generate(items.length - 1, (index) => items[index][0]);
    _icons = List.generate(items.length, (index) => items[index][1]);
    _lables = List.generate(items.length, (index) => items[index][2]);
  }

  @override
  List<dynamic> createPage(Widget page, Image iconData, String bottomLable) {
    // TODO: implement createPage
    return [page, iconData, bottomLable];
    throw UnimplementedError();
  }
}

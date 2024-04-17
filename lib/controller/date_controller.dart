import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
 import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class DateController extends GetxController
{

  late DateTime gregorianDate;
  late HijriCalendar hijriDate;

  initilizeDate()async
  {
    await initializeDateFormatting("ar_SA", null);
    gregorianDate= DateTime.now();
    HijriCalendar.setLocal("ar");
    hijriDate=HijriCalendar.now();

   }

String getDayName(){
    return DateFormat("EEEE","ar").format(gregorianDate);
}

  int dyasToRamadan()  {


       var miladi=hijriDate.hijriToGregorian(hijriDate.hYear,9, 1);

      if(miladi.isBefore(gregorianDate))
        miladi=hijriDate.hijriToGregorian(hijriDate.hYear+1,9, 1);

      return (miladi.difference(gregorianDate)).inDays;
  }

  String getGregorianDate()
  {
    return "${gregorianDate.day}-${gregorianDate.month} -${gregorianDate.year}";

  }

  String getHijriDate()

  {
    return "${hijriDate.hDay}-${hijriDate.longMonthName} -${hijriDate.hYear}";


  }

 int testMonth()
  {

    if(hijriDate.hMonth==9)
           return 1;// ramdan

    else if(hijriDate.hMonth==10 && hijriDate.hDay<=3)
           return 2;

   else if(hijriDate.hMonth==12 && hijriDate.hDay<=4)
          return 3;

   else  return 0;

  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    initilizeDate();
    update();
  }
}
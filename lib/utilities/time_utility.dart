import 'package:prayertimes1/model/prayer.dart';

Map<String, dynamic> calculateNearestTime(List<PrayerModel> prayer_times) {
DateTime now=DateTime.now();

          print("AAAAAAAA ${now.hour}");
  List<DateTime> times = List<DateTime>.generate(
      prayer_times.length, (index) => prayer_times[index].time!);


  DateTime? nearestPrayerTime;
  Duration? smallestDifference;


  for(int i=0;i<times.length;i++) {
    if (times[i].isBefore(now))
      times[i] = times[i].add(Duration(days: 1));
  }

   List<Duration> deferences =
      times.map((tm) => (tm.difference(now)).abs()).toList();

  int nearestIndex = deferences.indexOf(
      deferences.reduce((a, b) => a.inMilliseconds < b.inMilliseconds ? a : b));

  Duration remainingTime = times[nearestIndex].difference(now);
  print("DEFER ${times} \n ----------------------- \n ${deferences}"
      " \n ${times[0].difference(now).inHours} ");

  if (remainingTime.inMinutes < -1) {
    if (++nearestIndex > 5) {
      nearestIndex = 0;
      remainingTime =
          times[nearestIndex].add(Duration(days: 1)).difference(now);
    } else
      remainingTime = times[nearestIndex].difference(now);
  }


  //print(">>>>>>${prayer_times[nearestIndex].name} ${remainingTime.inHours} ${remainingTime.inMinutes.remainder(60)}  ${remainingTime.inSeconds.remainder(60)}" );

  return {
    'index': nearestIndex,
    'name': prayer_times[nearestIndex].name,
    'remaininghours': remainingTime.inHours < 0 ? 0 : remainingTime.inHours,
    'remainingminutes': remainingTime.inMinutes.remainder(60) < 0
        ? 0
        : remainingTime.inMinutes.remainder(60),
    'remainingsecond': remainingTime.inSeconds.remainder(60) < 0
        ? 0
        : remainingTime.inSeconds.remainder(60)
  };
}

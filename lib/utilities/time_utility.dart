import 'package:prayertimes1/model/prayer.dart';

Map<String, dynamic> calculateNearestTime(List<PrayerModel> prayer_times) {
  List<DateTime> times = List<DateTime>.generate(
      prayer_times.length, (index) => prayer_times[index].time!);

  List<Duration> deferences =
      times.map((tm) => tm.difference(DateTime.now()).abs()).toList();
  print("DEFER ${deferences}");
  int nearestIndex = deferences.indexOf(
      deferences.reduce((a, b) => a.inMilliseconds < b.inMilliseconds ? a : b));

  Duration remainingTime = times[nearestIndex].difference(DateTime.now());

  if (remainingTime.inMinutes < -1) {
    if (++nearestIndex > 5) {
      nearestIndex = 0;
      remainingTime =
          times[nearestIndex].add(Duration(days: 1)).difference(DateTime.now());
    } else
      remainingTime = times[nearestIndex].difference(DateTime.now());
  }

  print(DateTime.now());
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

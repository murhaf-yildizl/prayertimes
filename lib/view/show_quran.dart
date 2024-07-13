import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import '../main.dart';

class QuraanSound extends StatefulWidget {
  QuraanSound({key}) : super(key: key);

  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<QuraanSound> with TickerProviderStateMixin {
  //for audio files
  late AnimationController _animationIconController;
  late AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration(seconds: 0);
  late double durationValue;
  bool isPlaying = false;
  String? url;
  List<Map<String, String>> soundList = [];
  int? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //for audio inside initState

    initializData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        toolbarHeight: screen_height * 0.10,
        title: Text(
          "القرآن الــكريــم",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: icon_size,
              color: Colors.white,
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: screen_height * 0.08,
                width: screen_width * 0.60,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.pink[600],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Marquee(
                    text: selectedItem != null
                        ? soundList[selectedItem!]['title']! +
                            "-" +
                            soundList[selectedItem!]['subtitle']!
                        : 'الـــقـــرآن الــــكريــــم',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                    textDirection: TextDirection.rtl,
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 20.0,
                    velocity: 10.0,
                    pauseAfterRound: Duration(seconds: 1),
                    startPadding: 20.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (url == null) return;
                      // Add code to pause and play the music.
                      if (!isPlaying) {
                        audioPlayer.play(AssetSource(url!));
                        setState(() {
                          isPlaying = true;
                        });
                      } else {
                        audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      }
                    },
                    child: ClipOval(
                      child: Container(
                        color: Colors.pink[600],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedIcon(
                            icon: !isPlaying
                                ? AnimatedIcons.play_pause
                                : AnimatedIcons.pause_play,
                            size: 14,
                            progress: _animationIconController,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screen_width * 0.80,
                    child: Slider(
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        seekToSeconds(value.toInt());
                        value = value;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: audioPlayer.getCurrentPosition().asStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Duration?> duration) {
                      if (duration.data != null) {
                        int remaininghours = duration.data!.inHours < 0
                            ? 0
                            : duration.data!.inHours;
                        int remainingminutes =
                            duration.data!.inMinutes.remainder(60) < 0
                                ? 0
                                : duration.data!.inMinutes.remainder(60);
                        int remainingsecond =
                            duration.data!.inSeconds.remainder(60) < 0
                                ? 0
                                : duration.data!.inSeconds.remainder(60);

                        String text =
                            "$remaininghours:$remainingminutes:$remainingsecond";

                        return Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.normal),
                        );
                      }

                      return Text('');
                    },
                  ),
                  selectedItem != null ? Text(" / ") : Text(""),
                  StreamBuilder(
                    stream: audioPlayer.getDuration().asStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Duration?> duration) {
                      if (duration.data != null) {
                        int remaininghours = duration.data!.inHours < 0
                            ? 0
                            : duration.data!.inHours;
                        int remainingminutes =
                            duration.data!.inMinutes.remainder(60) < 0
                                ? 0
                                : duration.data!.inMinutes.remainder(60);
                        int remainingsecond =
                            duration.data!.inSeconds.remainder(60) < 0
                                ? 0
                                : duration.data!.inSeconds.remainder(60);

                        String text =
                            "$remaininghours:$remainingminutes:$remainingsecond";

                        return Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.normal),
                        );
                      }

                      return Text('');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              for (var i = 0; i < soundList.length; i++) drawCard(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawCard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          audioPlayer.play(AssetSource(soundList[index]['path']!));
          isPlaying = true;
          selectedItem = index;
          url = soundList[index]['path']!;
        });
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
            color: Colors.teal[300],
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: selectedItem == index ? Colors.red : Colors.grey,
                      width: 3)),
              child: ListTile(
                title: Text(
                  soundList[index]['title']!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight:
                          selectedItem == index ? FontWeight.bold : null,
                      fontSize:
                          selectedItem == index ? large_text : medium_text,
                      color: Colors.white),
                ),
                subtitle: Text(soundList[index]['subtitle']!,
                    style: TextStyle(
                        fontWeight:
                            selectedItem == index ? FontWeight.bold : null,
                        fontSize:
                            selectedItem == index ? large_text : medium_text,
                        color: Colors.white)),
              ),
            )),
      ),
    );
  }

  void initializData() {
    soundList = [
      {
        'title': 'سورة يوسف',
        'subtitle': 'الشيخ ماهر المعيقلي',
        'path': 'quraan/quraan1.mp3'
      },
      {
        'title': 'سورة الكهف',
        'subtitle': 'الشيخ ماهر المعيقلي',
        'path': 'quraan/quraan2.mp3'
      },
      {
        'title': 'سورة مريم',
        'subtitle': 'الشيخ أحمد العجمي',
        'path': 'quraan/quraan4.mp3'
      },
      {
        'title': 'تلاوة نادرة من مسجد لالا باشا بدمشق',
        'subtitle': 'الشيخ محمد صدّيق المنشاوي',
        'path': 'quraan/quraan5.mp3'
      },
      {
        'title': 'سورة الأنبياء',
        'subtitle': 'الشيخ سعد الغامدي',
        'path': 'quraan/quraan3.mp3'
      }
    ];

    _animationIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );

    audioPlayer = AudioPlayer();

    audioPlayer.onDurationChanged.listen((value) {
      setState(() {
        _duration = value;
      });
    });

    audioPlayer.onPositionChanged.listen((value) {
      setState(() {
        _position = value;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  void seekToSeconds(int second) {
    audioPlayer.seek(Duration(seconds: second));
  }
}

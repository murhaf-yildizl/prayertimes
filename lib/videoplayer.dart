import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';

List<Map<String, String>> videoes = [
  {
    'title': 'سورة يوسف',
    'subtitle': 'الشيخ ماهر المعيقلي',
    'path': 'assets/videoes/yussuf.mp4'
  },
  {
    'title': 'سورة الكهف',
    'subtitle': 'الشيخ ماهر المعيقلي',
    'path': 'assets/videoes/alkahf.mp4'
  },
  {
    'title': 'سورة مريم',
    'subtitle': 'الشيخ أحمد العجمي',
    'path': 'assets/videoes/meryam.mp4'
  },
  {
    'title': 'تلاوة نادرة من مسجد لالا باشا بدمشق',
    'subtitle': 'الشيخ محمد صدّيق المنشاوي',
    'path': 'assets/videoes/menshawi.mp4'
  },
  {
    'title': 'سورة الأنبياء',
    'subtitle': 'الشيخ سعد الغامدي',
    'path': 'assets/videoes/alanbiaa.mp4'
  }
];

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late CustomVideoPlayerController customVideoPlayerController;
  int selectedIndex = 0;
  bool isPlaying = false;
  bool itemPressed = false;

  @override
  void initState() {
    super.initState();
    initilization(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 120,
          title: Container(
            height: screen_height * 0.15,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/appbar.png'),
                  fit: BoxFit.fill),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "القرآن الكريم",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: icon_size,
                    )),
              ],
            )),
          )),
      body: Container(
        child: Column(
          children: [
            Container(
              height: screen_height * 0.30,
              width: double.infinity,
              child: isPlaying
                  ? CustomVideoPlayer(
                      customVideoPlayerController: customVideoPlayerController,
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: videoes.length,
                  itemBuilder: (context, index) {
                    return drawCard(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawCard(int index) {
    return InkWell(
      onTap: () {
        itemPressed = true;
        customVideoPlayerController.dispose();
        initilization(index);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: selectedIndex == index ? Colors.green : Colors.grey,
                  width: 2)),
          child: ListTile(
            title: Text(
              videoes[index]['title']!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: selectedIndex == index ? FontWeight.bold : null,
                  fontSize: selectedIndex == index ? medium_text : small_text),
            ),
            subtitle: Text(videoes[index]['subtitle']!),
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initilization(int index) async {
    CachedVideoPlayerController videoPlayerController =
        await CachedVideoPlayerController.asset(videoes[index]['path']!)
          ..initialize().then((value) {
            setState(() {
              selectedIndex = index;
              isPlaying = true;
            });
          });

    customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    if (itemPressed) customVideoPlayerController.videoPlayerController.play();
  }
}

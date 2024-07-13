import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/azkar.dart';

import 'show_single_azkar.dart';

class ShowAzkar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedGridViewWidget();
  }
}

class AnimatedGridViewWidget extends StatefulWidget {
  @override
  _AnimatedGridViewWidgetState createState() => _AnimatedGridViewWidgetState();
}

class _AnimatedGridViewWidgetState extends State<AnimatedGridViewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/mosque11.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            drawTitle(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 18.0,
                ),
                itemCount: azkar.length,
                itemBuilder: (context, index) {
                  return drawCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget drawCard(int index) {
    return ScaleTransition(
      scale: _animation,
      child: InkWell(
        onTap: () {
          Get.to(SingleAzkar(map: azkar[index]));
        },
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text('${azkar[index].keys.first}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget drawTitle() {
    return Container(
      height: Get.height * 0.08,
      width: Get.width * 0.90,
      decoration: BoxDecoration(
          color: Colors.indigo, borderRadius: BorderRadius.circular(30)),
      child: Center(
          child: Text(
              "فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white))),
    );
  }
}

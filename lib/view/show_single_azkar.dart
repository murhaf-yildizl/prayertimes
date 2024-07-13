import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';

class SingleAzkar extends StatelessWidget {
  Map<String, dynamic> map = {};

  SingleAzkar({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    print(map.values.first.length);
    return Scaffold(
      body: Container(
        height: screen_height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/mosque11.jpg"),
                fit: BoxFit.cover)),
        child: ListView.builder(
          itemCount: map.values.first.length + 1,
          itemBuilder: (context, index) {
            if (index == 0)
              return iconButton();
            else
              return drawItems(map.values.first[index - 1], context);
          },
        ),
      ),
    );
  }

  Widget drawItems(item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          elevation: 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                item,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconButton() {
    return IconButton(
        onPressed: () {
          Navigator.pop(Get.context!);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.red,
          size: icon_size,
        ));
  }
}

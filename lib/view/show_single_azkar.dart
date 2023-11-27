

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleAzkar extends StatelessWidget {
  Map<String,dynamic> map={};

    SingleAzkar({super.key,required this.map});

  @override
  Widget build(BuildContext context) {
    print(map.values.first.length);
      return Scaffold(
        body: Container(
          height: Get.height,
           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage("assets/images/mosque11.jpg"),
               fit: BoxFit.cover
             )
           ),
           child: ListView.builder(
            itemCount: map.values.first.length+1,
              itemBuilder:(context,index)
              {
                if(index==0)
                     return iconButton();
                else return drawItems(map.values.first[index-1]);
              },
           ),
        ),
      );
  }

  Widget drawItems(item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: Colors.indigo,
          elevation: 3,
          child: Center(child:
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(item,style: TextStyle(fontFamily:'lateef',fontSize: 24,color: Colors.white,letterSpacing:1,wordSpacing: 1,height: 2),),
            )
            ,),
        ),
      ),
    );
  }

  Widget iconButton() {
    return IconButton(
        onPressed: (){
          Navigator.pop(Get.context!);
        },
        icon:Icon(Icons.arrow_back_ios,color: Colors.red,size: 40,)
    );
  }
}

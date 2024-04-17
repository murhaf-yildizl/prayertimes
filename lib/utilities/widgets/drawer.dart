import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import 'package:prayertimes1/view/show_quran.dart';
import '../../view/show_azan.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isOver=false;
  List<String>titles=["القرآن الكريم","الأحاديث","كتب إسلامية","الإعدادات"];
  List<String>icons=[
    "assets/images/quran-icon.png",
    "assets/images/ahadith.png",
    "assets/images/books.png",
    "assets/images/settings.png"
  ];


  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: Get.width*0.90,
         height: Get.height*0.70,
         padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(170),
            color:Colors.transparent,
            //borderRadius: BorderRadius.circular(200),

            image: const DecorationImage(
                image: AssetImage("assets/images/mosque11.jpg",),
                fit: BoxFit.cover
            )
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children:  [
                SizedBox(height:20),
                for(int i=0;i<titles.length;i++)
                  drawItem(i)
              ],
            ),
          ),
        ),
      ),
    );


  }

  drawItem(int index)
  {
     return  Padding(
      padding: const EdgeInsets.only(bottom:16),
      child: MouseRegion(
        onEnter: (e)=>setState(()=>isOver=true),
        onExit:  (e)=>setState(()=>isOver=false),
        child: InkWell(
          onTap: (){
           if(index==0)
              Get.to(QuraanSound());

          else if(index==3)
                 Get.to(AzanSound());

            else Get.to(ShowItem());
          },
          child: AnimatedContainer(
            width: screen_width*0.60,
            height: screen_height*0.10,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isOver?1.1:1.0),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                 //color: Colors.red,
                  width: screen_width*0.30,
                  child: Text(titles[index],style:Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white))),
              Container(
                //color: Colors.black,
                  width: screen_width*0.10,
                  height: screen_width*0.10,
                  child: Image.asset(icons[index],width: screen_width*0.10,height: screen_width*0.10,)) ,
            ]
            ),
          ),
        ),
      ),
    );

  }
}


class ShowItem extends StatelessWidget {
    ShowItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body:  Container(
        color:Colors.white,
        child: Center(child: Text('القائمة قيد الإنشاء',style: TextStyle(fontFamily: 'lteef',fontSize: 24),),),
      ),
    );
  }
}

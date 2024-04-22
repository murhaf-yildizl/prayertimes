import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:prayertimes1/utilities/device_dimensions.dart';
import '../controller/prayer_controller.dart';
import '../main.dart';

class AzanSound extends StatefulWidget {

  AzanSound({ key}) : super(key: key);

  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<AzanSound> with TickerProviderStateMixin{
  //for audio files
  late AnimationController _animationIconController;
  late AudioPlayer audioPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration(seconds:0);
  late double durationValue;
  bool isPlaying = false;
  String? url;
  List<Map<String,String>>soundList=[];
  int? selectedItem;
  String? selectedAzan;

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
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        toolbarHeight: screen_height*0.10,
        title: Text("اختيار صوت الأذان",style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),),
        leading: IconButton(
            onPressed:(){Get.back(); },
            icon:Icon(Icons.arrow_back_ios_new_rounded,size: icon_size,color: Colors.white,)
        ),
      ),
      body: Container(

         child: SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               SizedBox(height: 20,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   GestureDetector(
                     onTap: () {

                       if(url==null)
                         return;
                       // Add code to pause and play the music.
                       if (!isPlaying){
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
                             icon: !isPlaying? AnimatedIcons.play_pause:AnimatedIcons.pause_play,
                             size: 14,
                             progress: _animationIconController,

                             color: Colors.white,
                           ),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(
                     width: screen_width*0.80,
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
              SizedBox(height: 20,),
              for(var i=0;i<soundList.length;i++)
               drawCard(i),
             ],
           ),
         ),
      ),
    );
  }


  Widget drawCard(int index) {

    return   InkWell(
      onTap: (){
        setState(() {
          audioPlayer.play(AssetSource(soundList[index]['path']!));
          isPlaying = true;
          selectedItem=index;
          url=soundList[index]['path']!;

        });
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          color: Colors.teal[300],
            child:Container(
              
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: selectedItem==index?Colors.red:Colors.grey,
                      width: 3
                  )
              ),
               child: ListTile(
                title:    Text(soundList[index]['title']!,
                          style:
                          Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight:selectedItem==index?FontWeight.bold:null,fontSize: selectedItem==index?large_text:medium_text,color: Colors.white ),),
                subtitle: Text(soundList[index]['subtitle']!,style: TextStyle(fontWeight:selectedItem==index?FontWeight.bold:null,fontSize: selectedItem==index?large_text:medium_text,color: Colors.white )),
                trailing: Container(
                  width: 100,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("اختيار",style:Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                      Radio(

                          activeColor: Colors.red,
                          groupValue: selectedAzan,
                          value: soundList[index]['path']!,
                          onChanged: (value){
                            setState(() {
                              String? azan=value?.split("/")[1].split(".")[0];
                             print("VALU $value");
                              if(azan!=null)
                              {
                                pref.setString("azan",azan);


                                 PrayerController().initilization();

                              }

                              selectedAzan=value;
                            });
                          }
                      ),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }


  void initializData() {

    soundList=[
      {'title':'الأذان ','subtitle':'الشيخ ناصر القطامي','path':'sounds/azan1.mp3'},
      {'title':'الأذان ','subtitle':'الشيخ مصطفى اسماعيل','path':'sounds/azan2.mp3'},
      {'title':'أذان الجامع الأموي بدمشق','subtitle':'أذان جماعي','path':'sounds/azan3.mp3'},
      {'title':'الأذان بمقام الحجاز','subtitle':'الشيخ مصطفى العزاوي','path':'sounds/azan4.mp3'},
    ];


    String azan=pref.getString("azan")??'azan4';
    int index=0;

    switch(azan)
    {
      case 'azan1':{ index=0; break;}
      case 'azan2':{ index=1; break;}
      case 'azan3':{ index=2; break;}
      case 'azan4':{ index=3; break;}


    }

    selectedAzan= soundList[index]['path']!;

    print("selected $selectedAzan");
    _animationIconController = AnimationController(
      vsync: this,
      duration:   Duration(milliseconds: 750),
      reverseDuration:   Duration(milliseconds: 750),
    );

    audioPlayer =   AudioPlayer();

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
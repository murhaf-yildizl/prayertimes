import 'package:flutter/material.dart';

late double  large_text;
late double  medium_text;
late double  small_text;
late double button_height;
late double icon_size;
late double screen_height,screen_width;

deviceDemensions(BuildContext context) {

  screen_height=MediaQuery.of(context).size.height;
  screen_width= MediaQuery.of(context).size.width;

  print("kkkkkkkkkkkkkkkk $screen_height   $screen_width  ${screen_width/screen_height}");



  if (screen_height >= 1000)
  {
    print("PPPPPPPPPPPPPPPPP }");
    large_text= 38;
    medium_text=32;
    small_text=24;
    button_height=110;
    //return ScreenSize.ExtraLarge;
    icon_size=50;

  }

  else if (screen_height >= 900)
  {
    large_text= 24;
    medium_text=18;
    small_text=16;
    button_height=90;
    icon_size=45;

  } //return ScreenSize.Large;

  else if (screen_height >=800)
  {
    large_text= 22;
    medium_text=20;
    small_text=16;
    button_height=80;
    icon_size=40;
   } //re

  else if (screen_height >=600)
  {
    large_text= 18;
    medium_text=16;
    small_text=12;
    button_height=80;
    icon_size=35;
   } //return ScreenSize.Normal;
  else
  {
    large_text= 16;
    medium_text=14;
    small_text=12;
    button_height=60;
    icon_size=30;

  }

  if(screen_width>=800 && screen_height>1200)
  {

   }

}


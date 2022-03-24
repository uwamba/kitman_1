import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import 'PrefData.dart';
import 'SizeConfig.dart';

class ConstantData {
  static Color primaryColor = "#175AAF".toColor();
  // static Color primaryColor = "#07A9F0".toColor();


  static Color accentColor = "#FF9800".toColor();
  static Color bgColor = "#F9F9FB".toColor();
  static Color viewColor = "#F1F1F1".toColor();
  static Color cellColor = "#F1F1F1".toColor();
  // static Color cellColor = "#E4E6ED".toColor();
  static String fontFamily = "SFProText";
  static String assetsPath = "assets/images/";

  static String dateFormat = "EEE ,MMM dd,yyyy";

  static const double avatarRadius = 40;
  static Color mainTextColor = "#030303".toColor();
  static Color borderColor = Colors.grey.shade400;
  static Color shadowColor = Colors.grey.shade100;
  // static Color mainTextColor = "#084043".toColor();
  static Color textColor = "#4E4E4E".toColor();
  static Color color1 = "#E46756".toColor();
  static Color color2 = "#E4BC39".toColor();
  static Color color3  = "#175AAE".toColor();
  static Color color4 = "#1BA454".toColor();
  static Color color5 = "#721FA2".toColor();
  static Color cartColor = "#F1F1F1".toColor();



  static String privacyPolicy = "https://google.com";
  static double font15Px = SizeConfig.safeBlockVertical / 0.6;

  static double font12Px = SizeConfig.safeBlockVertical / 0.75;

  static double font18Px = SizeConfig.safeBlockVertical / 0.5;
  static double font22Px = SizeConfig.safeBlockVertical / 0.4;
  static double font25Px = SizeConfig.safeBlockVertical / 0.3;


  static const double padding = 20;

  static String timeFormat = "hh:mm aa";


  static Color getOrderColor(String s){
    if(s.contains("On Delivery")){
      return "#FFEDCE".toColor();
    }else if(s.contains("Completed")){
      return primaryColor;
    }else{
      return Colors.red;
    }
  }


  static Color getPrescriptionColor(String s){
    if(s.contains("Submitted")){
      return accentColor;
    }else if(s.contains("Approved")){
      return Colors.green;
    }else{
      return Colors.redAccent;
    }
  }
  static Color getIconColor(String s){
    if(s.contains("On Delivery")){
      return accentColor;
    }else{
      return Colors.white;
    }
  }

  static colorList(){
    List<Color> colorList=[];
    colorList.add(color1);
    colorList.add(color2);
    colorList.add(color3);
    colorList.add(color4);
    colorList.add(color5);
    return colorList;
  }
  static setThemePosition() async {
    int themMode = await PrefData.getThemeMode();

    print("themeMode-----$themMode");




    if (themMode == 1) {
      textColor = Colors.white70;
      bgColor = "#14181E".toColor();
      viewColor = "#292929".toColor();
      cellColor = "#252525".toColor();
      mainTextColor = Colors.white;
      borderColor = Colors.white70;
      shadowColor = Colors.black87;

      cartColor = "#1E1D26".toColor();
      viewColor = "#1E1D26".toColor();

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.black
      ));

    } else {
      textColor = "#0A2A2C".toColor();
      bgColor = "#F9F9FB".toColor();
      viewColor = Colors.grey.shade100;
      cellColor = "#ffffff".toColor();
      // mainTextColor = "#084043".toColor();
      mainTextColor = "#030303".toColor();
      borderColor = Colors.grey.shade400;
      shadowColor = Colors.grey;
      cartColor = "#F1F1F1".toColor();

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: primaryColor
      ));


    }
  }



}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

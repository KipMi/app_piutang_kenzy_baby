import 'package:flutter/material.dart';

class ScreenSize {
  static double? width;
  static double? height;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    blockSizeHorizontal = width! / 100;
    blockSizeVertical = height! / 100;
  }
}

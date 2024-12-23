import 'package:flutter/material.dart';

var primaryColor = const Color(0xffF4A261);
var warningColor = const Color(0xffE9C46A);
var dangerColor = const Color(0xffE76F51);
var successColor = const Color(0xff2A9D8F);
var greyColor = const Color(0xffAFAFAF);

TextStyle headerStyle({int level = 1, bool dark = true}) {
  List<double> levelSize = [30, 24, 20, 14, 12];

  return TextStyle(
      fontSize: levelSize[level - 1],
      fontWeight: FontWeight.bold,
      color: dark ? Colors.black : Colors.white);
}

var buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 15),backgroundColor: primaryColor
);

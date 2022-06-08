import 'package:flutter/material.dart';

class ThemeNotes {
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Color(0xff292d36),
    primaryColor: Colors.white54,
    canvasColor: Colors.white,
    buttonColor: Colors.purple[200],
  );
  static final lightTheme = ThemeData.light().copyWith(
    primaryColorBrightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffF2F3F7),
    backgroundColor: Colors.white,
    primaryColor: Colors.grey,
    buttonColor: Colors.blue,
    canvasColor: Colors.black,
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/landingPage.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF171432),
      accentColor: const Color(0xFFFBC012),
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        title: TextStyle(fontSize: 18.0, color: Colors.white),
        caption: TextStyle(fontSize: 12.0, color: Colors.white),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: LandingPage(),
  ));
}

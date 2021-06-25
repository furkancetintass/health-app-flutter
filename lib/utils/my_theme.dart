import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: CupertinoColors.systemGreen,
      textTheme: TextTheme(
          title: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'))),
  fontFamily: 'Poppins',
  buttonColor: Colors.white,
  cardColor: Colors.white,
  primaryIconTheme: IconThemeData(color: Colors.white),
  primarySwatch: Colors.grey,
  primaryColor: CupertinoColors.activeGreen,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: CupertinoColors.activeGreen,
  unselectedWidgetColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.grey),
  dividerColor: Colors.grey,
  indicatorColor: Colors.grey,
  snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black54, actionTextColor: Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey.shade700),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffF2F2F2), width: 1),
    ),
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      //borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Color(0xffF2F2F2), width: 1),
    ),
  ),
);

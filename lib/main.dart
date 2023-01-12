import 'package:daily_meal_app/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway'
        ),
        home: HomePage(),
      ));
}

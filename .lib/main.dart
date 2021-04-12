import 'package:inphomeet/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InPhoMeeT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'modern',
        primarySwatch: Colors.cyan,
        accentColor: Colors.greenAccent,
      ),
      home: Home(),
    );
  }
}

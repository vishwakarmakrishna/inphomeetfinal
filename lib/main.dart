import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inphomeet/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:inphomeet/views/nearified.dart';
import 'package:inphomeet/models/user_location.dart';
import 'package:inphomeet/services/location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.settings(
  //   timestampsInSnapshotsEnabled: true,
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        title: 'InPhoMeeT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'keep',
          // scaffoldBackgroundColor: Colors.grey[800],
          primarySwatch: Colors.blue,
          accentColor: Colors.deepPurpleAccent[700],
        ),
        home: Home(),
      ),
    );
  }
}

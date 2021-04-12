import 'dart:async';

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// ignore: unused_import
import 'package:inphomeet/models/saveuser.dart';
import 'package:inphomeet/models/user_location.dart';

//import 'package:inphomeet/pages/contactspage.dart';
import 'package:inphomeet/pages/home.dart';

//import 'package:inphomeet/widgets/progress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
//import 'package:inphomeet/models/saveuser.dart';

class Nearify extends StatefulWidget {
  final String nearifyId;
  final String phoneNumber;
  Nearify({
    this.nearifyId,
    this.phoneNumber,
  });
  @override
  _NearifyState createState() => _NearifyState();
}

class _NearifyState extends State<Nearify> {
  //String _locationMessage = "";

  String currentlat = "";

  String currentlong = "";
  String _completeAddress = "";
  bool status = false;
  String mobileNumber = "";

  createPostInFirestore(
    String lat,
    String long,
    String completeAddress,
  ) {
    nearifyRef.doc(widget.nearifyId).set({
      "completeAddress": completeAddress,
      "currentlat": lat,
      "currentlong": long,
    });
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];

    setState(() {
      currentlat = "${position.latitude}";
      currentlong = "${position.longitude}";

      _completeAddress =
          '${placemark.subThoroughfare} \n${placemark.thoroughfare}, \n${placemark.subLocality} \n${placemark.locality}, \n${placemark.subAdministrativeArea}, \n${placemark.administrativeArea} \n${placemark.postalCode}, \n${placemark.country}';
      createPostInFirestore(currentlat, currentlong, _completeAddress);
      //_locationMessage = "latitude: $currentlat, \n longitude: $currentlong \n";
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearify",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "rage",
            fontSize: 40.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            color: Colors.black,
            onPressed: () async {
              final PermissionStatus permissionStatus = await _getPermission();
              if (permissionStatus == PermissionStatus.granted) {
                _getCurrentLocation();
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Permissions error'),
                          content: Text(
                              'Please enable location as always access '
                              'permission in system settings.\n'
                              'we will only store your data for better user experience'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('OK'),
                              onPressed: () {
                                _getCurrentLocation();
                              },
                            )
                          ],
                        ));
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Text(
              "Your Location is below",
              style: TextStyle(
                fontFamily: "keep",
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 12.0,
            ),
            AdvancedSwitch(
              value: status,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              //activeChild: Text('ON'),
              //inactiveChild: Text('OFF'),
              //activeImage: AssetImage('assets/images/on.png'),
              //inactiveImage:AssetImage('assets/images/off.png'),
              borderRadius:
                  BorderRadius.all(const Radius.circular(15)), // BorderRadius
              width: 50.0, // Double
              height: 30.0, // Double
              onChanged: (value) => setState(() {
                // Callback (or null to disable)
                status = value;
                if (value = true) {
                  _getCurrentLocation();
                }
              }),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
                'Location: Lat:${userLocation.latitude}, Long: ${userLocation.longitude}'),
            SizedBox(
              height: 12.0,
            ),
            Text(
              'Value : $status',
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}

class NearifyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Nearify Item');
  }
}

Future<PermissionStatus> _getPermission() async {
  final PermissionStatus permission = await Permission.locationWhenInUse.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.locationWhenInUse].request();
    return permissionStatus[Permission.locationWhenInUse] ??
        PermissionStatus.undetermined;
  } else {
    return permission;
  }
}

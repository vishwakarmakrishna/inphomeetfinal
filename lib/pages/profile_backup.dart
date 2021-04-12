import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inphomeet/pages/home.dart';
import 'package:inphomeet/widgets/header.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Profile",
              style: TextStyle(
                fontFamily: "rage",
                fontSize: 60.0,
                color: Colors.orangeAccent[100],
              ),
            ),
            SizedBox(height: 6),
            ElevatedButton(
              child: Text(
                'Logout',
              ),
              onPressed: () {
                googleSignIn.disconnect();
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: header(context, titleText: "Profile"),
    //   body: Center(
    //     child: Container(
    //       alignment: Alignment.center,
    //       color: Colors.blueGrey.shade900,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Text(
    //             "Profile",
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           SizedBox(height: 6),
    //           CircleAvatar(
    //             maxRadius: 25,
    //             backgroundImage: NetworkImage(user.photoURL),
    //           ),
    //           Text(
    //             "Name: " + user.displayName,
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           Text(
    //             "Email: " + user.email,
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           SizedBox(height: 6),
    //           ElevatedButton(
    //             child: Text('Signed Out'),
    //             onPressed: () {
    //               googleSignIn.disconnect();
    //               FirebaseAuth.instance.signOut();
    //             },
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

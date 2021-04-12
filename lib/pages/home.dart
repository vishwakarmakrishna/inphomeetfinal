import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

import 'package:inphomeet/models/saveuser.dart';

import 'package:inphomeet/pages/activity_feed.dart';
//import 'package:inphomeet/pages/nearify.dart';
import 'package:inphomeet/pages/create_account.dart';
import 'package:inphomeet/pages/profile.dart';
// ignore: unused_import
//import 'package:inphomeet/views/nearified.dart';
import 'package:inphomeet/pages/search.dart';
import 'package:inphomeet/pages/chat.dart';
// ignore: unused_import
import 'package:inphomeet/pages/activity2.dart';
import 'package:inphomeet/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:neon/neon.dart';
//import 'package:firebase_core/firebase_core.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
var firebaseUser = FirebaseAuth.instance.currentUser;
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final nearifyRef = FirebaseFirestore.instance.collection('nearify');
final nearifiedRef = FirebaseFirestore.instance.collection('nearified');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final chatsRef = FirebaseFirestore.instance.collection('chats');

final DateTime timestamp = DateTime.now();
SaveUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: deprecated_member_use
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      //print('User signed in!: $account');
      await createUserInFirestore();
      setState(() {
        isAuth = true;
      });
      configurePushNotifications();
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotifications() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermission();

    _firebaseMessaging.getToken().then((token) {
      // print("Firebase Messaging Token: $token\n");
      usersRef.doc(user.id).update({"androidNotificationToken": token});
    });

    _firebaseMessaging.configure(
      onBackgroundMessage: (Map<String, dynamic> message) async {
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == user.id) {
          // print("Notification shown!");
          SnackBar snackbar = SnackBar(
              content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ));
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == user.id) {
          // print("Notification shown!");
          SnackBar snackbar = SnackBar(
              content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ));
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == user.id) {
          // print("Notification shown!");
          SnackBar snackbar = SnackBar(
              content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ));
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
      onMessage: (Map<String, dynamic> message) async {
        // print("on message: $message\n");
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == user.id) {
          // print("Notification shown!");
          SnackBar snackbar = SnackBar(
              content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ));
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
        //print("Notification NOT shown");
      },
    );
  }

  getiOSPermission() {
    // ignore: deprecated_member_use
    _firebaseMessaging.requestNotificationPermissions(
        // ignore: deprecated_member_use
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      //print("Settings registered: $settings");
    });
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final phoneNumber = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      // String currentlat = await Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Nearify()));
      // String currentlong = await Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Nearify()));

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "phoneNumber": phoneNumber,
        //"userName": userName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      await followersRef
          .doc(user.id)
          .collection('userFollowers')
          .doc(user.id)
          .set({});
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = SaveUser.fromDocument(doc);
    // print(currentUser.displayName);
    // print(currentUser.phoneNumber);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 22),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          Chat(currentUser: currentUser),
          Search(),
          Upload(currentUser: currentUser),
          //Nearify(nearifyId: currentUser?.id),
          //Main2(),
          ActivityFeed(),
          // ActivityFeed(nearifyId: currentUser?.id),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: pageIndex,
        style: TabStyle.reactCircle,
        disableDefaultTabController: true,
        onTap: onTap,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent[700],
            Colors.blue[800],
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
        elevation: 5,
        activeColor: Colors.black.withOpacity(0.1),

        //backgroundColor: Colors.white.withOpacity(0.1),
        //inactiveColor: Colors.black,
        items: [
          TabItem(
            icon: Icon(
              Icons.supervised_user_circle_outlined,
              color: Colors.white.withOpacity(1),
            ),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.white.withOpacity(1),
            ),
            title: 'Search',
          ),
          TabItem(
            icon: Icon(
              Icons.linked_camera_outlined,
              color: Colors.white.withOpacity(1),
              //  size: 45.0,
            ),
            title: 'Uplaod',
          ),
          TabItem(
            icon: Icon(
              Icons.near_me_outlined,
              color: Colors.white.withOpacity(1),
            ),
            title: 'Activities',
          ),
          TabItem(
            icon: Icon(
              Icons.emoji_people_outlined,
              color: Colors.white.withOpacity(1),
            ),
            title: 'Profile',
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        //margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purpleAccent[700],
              Colors.blue[800],
            ],
          ),
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(
            width: MediaQuery.of(context).size.width / 100,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // GradientText(
            //   'InPhoMeeT',
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Colors.white,
            //       Colors.yellowAccent,
            //     ],
            //   ),
            //   style: TextStyle(
            //     fontFamily: "modern",
            //     fontSize: 50,
            //     color: Colors.white,
            //   ),
            // ),
            Neon(
              text: 'InPhoMeeT',
              blurRadius: 50,
              color: Colors.blue,
              fontSize: 50,
              font: NeonFont.Beon,
              // flickeringText: true,
              glowing: false,
              glowingDuration: const Duration(milliseconds: 1500),
              // flickeringLetters: [0, 1],
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(50),
              child: Stack(
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/images/lottie/background3.json',
                      //width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 4,
                      reverse: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Lottie.asset(
                      'assets/images/lottie/background5.json',

                      //width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Lottie.asset(
                      'assets/images/lottie/circle2.json',
                      //width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 4,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/launcher/foreground.png',
                      // width: double.maxFinite,
                      height: MediaQuery.of(context).size.height / 4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: login,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          spreadRadius: 16,
                          color: Colors.black.withOpacity(0.2),
                        )
                      ]),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(16.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 40.0,
                        sigmaY: 40.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(200.0),
                          border: Border.all(
                            width: 2.5,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Lottie.asset(
                          'assets/lotiee/google.json',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inphomeet/pages/activity_feed.dart';
import 'package:inphomeet/pages/profile.dart';
import 'package:inphomeet/pages/search.dart';
import 'package:inphomeet/pages/timeline.dart';
import 'package:inphomeet/pages/upload.dart';
//import 'package:firebase_core/firebase_core.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
var firebaseUser = FirebaseAuth.instance.currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User signed in!: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
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
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          Search(),
          Upload(),
          ActivityFeed(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot_rounded),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera_rounded,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.near_me),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded),
            ),
          ]),
    );
  }
  // Widget buildAuthScreen() {
  //   return RaisedButton(
  //     child: Text(
  //       'Logout',
  //     ),
  //     textColor: Color.alphaBlend(Colors.black, Colors.white),
  //     onPressed: logout,
  //   );
  // }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'INPHOMEET',
              style: TextStyle(
                fontFamily: "truelies",
                fontSize: 60.0,
                color: Colors.white,
              ),
            ),
            Text(''),
            Text(''),
            Center(
              child: Image.asset(
                'assets/images/main/rangeog.gif',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Text(''),
            Text(''),
            Center(
              child: Image.asset(
                'assets/images/main/continue.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/main/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
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

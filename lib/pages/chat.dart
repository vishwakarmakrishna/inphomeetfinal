import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inphomeet/models/saveuser.dart';
import 'package:inphomeet/pages/contactspage.dart';
import 'package:inphomeet/pages/home.dart';
import 'package:inphomeet/pages/search.dart';
import 'package:inphomeet/widgets/header.dart';
import 'package:inphomeet/widgets/post.dart';
import 'package:inphomeet/widgets/progress.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:inphomeet/widgets/progress.dart';

//final usersRef = Firestore.instance.collection('users');
//final usersRef = FirebaseFirestore.instance.collection('users');

class Chat extends StatefulWidget {
  final SaveUser currentUser;

  Chat({this.currentUser});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Post> posts;
  List<String> followingList = [];
  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(currentUser.id)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.docs.forEach((doc) {
          SaveUser user = SaveUser.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: true,
      ),
      body: Container(
          //color: Colors.amber[600],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
              onRefresh: () => getTimeline(), child: buildTimeline())

          //   ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.cyan,
          //     ),
          //     onPressed: () {},
          //     child: Container(
          //       width: double.maxFinite,
          //       child: Text(
          //         'See Contacts',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontFamily: "modern",
          //           fontSize: 20.0,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ),
          //   ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final PermissionStatus permissionStatus = await _getPermission();
          if (permissionStatus == PermissionStatus.granted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactsPage()));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Text('Permissions error'),
                      content: Text('Please enable contacts access '
                          'permission in system settings'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ));
          }
        },
        tooltip: 'See Contacts',
        child: Icon(Icons.add_comment_rounded),
      ),
    );
  }
}

Future<PermissionStatus> _getPermission() async {
  final PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ??
        PermissionStatus.undetermined;
  } else {
    return permission;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inphomeet/widgets/header.dart';
//import 'package:inphomeet/widgets/progress.dart';

//final usersRef = Firestore.instance.collection('users');
final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // getUsers();
    getUserById();
    super.initState();
  }

  // getUsers() {
  //   usersRef.getDocuments().then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((DocumentSnapshot doc) {
  //       print(doc.data);
  //       print(doc.documentID);
  //       print(doc.exists);
  //     });
  //   });
  // }
  getUserById() async {
    final String ids = "1zL9Op7nqYe5Jg9kKdI1";
    final DocumentSnapshot doc = await usersRef.doc(ids).get();
    print(doc.data);
    print(doc.id);
    print(doc.exists);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: Text('Timeline'),
    );
  }
}

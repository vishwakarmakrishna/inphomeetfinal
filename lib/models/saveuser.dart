import 'package:cloud_firestore/cloud_firestore.dart';

class SaveUser {
  final String id;
  final String phoneNumber;
  //final String userName;

  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  SaveUser({
    this.id,
    this.phoneNumber,
    //this.userName,

    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  factory SaveUser.fromDocument(DocumentSnapshot doc) {
    return SaveUser(
      id: doc['id'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      //userName: doc['userName'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}

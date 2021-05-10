import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String name;
  Map tokenMap;

  User(DocumentSnapshot doc) {
    userId = doc.id;
    name = doc.data()['name'];
    tokenMap = doc.data()['tokenMap'];
  }
}

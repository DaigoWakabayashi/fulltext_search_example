import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String id;
  String name;
  Map tokenMap;

  Member(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()['name'];
    tokenMap = doc.data()['tokenMap'];
  }
}

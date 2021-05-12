import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String id;
  String name;
  Map biGramTokenMap;

  Member(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()['name'];
    biGramTokenMap = doc.data()['biGramTokenMap'];
  }
}

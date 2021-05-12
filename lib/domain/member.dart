import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String id;
  String name;
  Map biGramMap;

  Member(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()['name'];
    biGramMap = doc.data()['biGramMap'];
  }
}

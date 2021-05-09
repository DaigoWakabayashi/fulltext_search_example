import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fulltext_search_example/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebaseを初期化するときに必要
  await Firebase.initializeApp(); // Firebaseを初期化
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full-Text Search Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

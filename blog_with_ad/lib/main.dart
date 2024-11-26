import 'package:flutter/material.dart';
import 'posts_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPress Posts',
      home: PostsPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

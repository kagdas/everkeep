// main.dart

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(EverkeepApp());
}

class EverkeepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everkeep',
      theme: ThemeData(
        primarySwatch:    Colors.purple,
      ),
      home: HomePage(),
    );
  }
}


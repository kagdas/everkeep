// main.dart
import 'package:flutter/material.dart';
// ignore: unused_import
import 'home_page.dart'; 
import 'login_page.dart'; // LoginPage dosyasını dahil ediyoruz

void main() {
  runApp(const EverkeepApp());
}

class EverkeepApp extends StatelessWidget {
  const EverkeepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Everkeep',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const LoginPage(), // Başlangıç sayfasını LoginPage olarak değiştiriyoruz
    );
  }
}

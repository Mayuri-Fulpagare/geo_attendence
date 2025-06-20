import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'widgets/bottom_nav.dart'; // 👈 Import bottom navigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // 👇 Set initial screen to LoginPage
      home: const LoginPage(),
    );
  }
}

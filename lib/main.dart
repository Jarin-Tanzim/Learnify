import 'package:flutter/material.dart';
import 'package:learnify/screens/splash_screen.dart';

void main() {
  runApp(const LearnifyApp());
}

class LearnifyApp extends StatelessWidget {
  const LearnifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learnify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FBFF),
        useMaterial3: true,
      ),
      home: const SplashScreen(), 
    );
  }
}
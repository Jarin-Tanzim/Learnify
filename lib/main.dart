import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnify/firebase_options.dart';
import 'package:learnify/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
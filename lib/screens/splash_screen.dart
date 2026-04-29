import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setupApp();
  }

  Future<void> setupApp() async {
    try {
await AuthService().signInAnonymously();
await FirestoreService().initializeUserProgress();    } catch (e) {
      debugPrint('Firestore setup failed: $e');
    }

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAF8FF),
              Color(0xFFFFF4A8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 34,
                      color: Color(0xFF0796B8),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Learnify',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0796B8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Text(
                  'Learning through play',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF102A43),
                  ),
                ),

                const SizedBox(height: 35),

                Container(
                  width: 210,
                  height: 210,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset(
                      'lib/assets/images/mascot.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: Color(0xFF8CCFE3)),
                    SizedBox(width: 10),
                    CircleAvatar(radius: 5, backgroundColor: Color(0xFF0796B8)),
                    SizedBox(width: 10),
                    CircleAvatar(radius: 5, backgroundColor: Color(0xFF0796B8)),
                    SizedBox(width: 10),
                    CircleAvatar(radius: 5, backgroundColor: Color(0xFF0796B8)),
                  ],
                ),

                const SizedBox(height: 22),

                const Text(
                  'READY TO PLAY?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Color(0xFF0796B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
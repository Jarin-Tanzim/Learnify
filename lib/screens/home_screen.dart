import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openCategory(BuildContext context, String title, String subtitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          title: title,
          subtitle: subtitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(showSettingsIcon: true),

              const SizedBox(height: 26),

              const Text(
                'Ready to Play?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF102A43),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CategoryCard(
                      title: 'ABC',
                      subtitle: 'Alphabets',
                      color: const Color(0xFFBDEBFF),
                      icon: Icons.text_fields_rounded,
                      onTap: () => openCategory(
                        context,
                        'Alphabets',
                        'Learn and play with letters',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CategoryCard(
                      title: '123',
                      subtitle: 'Numbers',
                      color: const Color(0xFFFFEE70),
                      icon: Icons.numbers_rounded,
                      onTap: () => openCategory(
                        context,
                        'Numbers',
                        'Learn numbers in a fun way',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CategoryCard(
                      title: '',
                      subtitle: 'Colors',
                      color: const Color(0xFFFFC6D9),
                      icon: Icons.palette_rounded,
                      onTap: () => openCategory(
                        context,
                        'Colors',
                        'Learn and play with colors',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CategoryCard(
                      title: '',
                      subtitle: 'Shapes',
                      color: const Color(0xFFE8EEF2),
                      icon: Icons.category_rounded,
                      onTap: () => openCategory(
                        context,
                        'Shapes',
                        'Learn and play with shapes',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

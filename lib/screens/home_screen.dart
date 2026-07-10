import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/app_header.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String childName = 'Learner';
  bool loading = true;

  Map<String, Map<String, dynamic>> progress = {};

  final List<Map<String, dynamic>> categories = [
    {
      'key': 'alphabets',
      'title': 'Alphabets',
      'icon': Icons.text_fields_rounded,
      'color': const Color(0xFFBDEBFF),
    },
    {
      'key': 'numbers',
      'title': 'Numbers',
      'icon': Icons.numbers_rounded,
      'color': const Color(0xFFFFEE70),
    },
    {
      'key': 'colors',
      'title': 'Colors',
      'icon': Icons.palette_rounded,
      'color': const Color(0xFFFFC6D9),
    },
    {
      'key': 'shapes',
      'title': 'Shapes',
      'icon': Icons.category_rounded,
      'color': const Color(0xFFE8EEF2),
    },
  ];

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      final name = await FirestoreService().getChildName();
      final loadedProgress = <String, Map<String, dynamic>>{};

      for (final category in categories) {
        final key = category['key'] as String;

        loadedProgress[key] =
            await FirestoreService().getCategoryProgress(key);
      }

      if (!mounted) return;

      setState(() {
        childName = name.trim().isEmpty ? 'Learner' : name.trim();
        progress = loadedProgress;
        loading = false;
      });
    } catch (e) {
      debugPrint('Could not load home data: $e');

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> openCategory(
    BuildContext context,
    String title,
    String subtitle,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          title: title,
          subtitle: subtitle,
        ),
      ),
    );

    await loadHomeData();
  }

  Future<void> openSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );

    await loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: AppHeader(showSettingsIcon: false),
                    ),
                    GestureDetector(
                      onTap: () => openSettings(context),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFEAF8FC),
                        child: Icon(
                          Icons.settings_rounded,
                          size: 22,
                          color: Color(0xFF0796B8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  loading ? 'Hello!' : 'Hello, $childName!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0796B8),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Ready to Play?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF102A43),
                  ),
                ),

                const SizedBox(height: 22),

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

                const SizedBox(height: 24),

                const Text(
                  'Learning Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF102A43),
                  ),
                ),

                const SizedBox(height: 14),

                if (loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < categories.length; i++) ...[
                          buildProgressRow(categories[i]),
                          if (i != categories.length - 1)
                            const Divider(height: 24),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProgressRow(Map<String, dynamic> category) {
    final key = category['key'] as String;
    final title = category['title'] as String;
    final icon = category['icon'] as IconData;
    final color = category['color'] as Color;

    final data = progress[key] ?? {};
    final int completed = data['completed'] ?? 0;
    final int total = data['total'] ?? 3;

    final double value = total == 0 ? 0 : completed / total;

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Icon(
            icon,
            size: 22,
            color: const Color(0xFF075E75),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ),
                  Text(
                    '$completed/$total',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0796B8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFFE8EEF2),
                color: const Color(0xFF0796B8),
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

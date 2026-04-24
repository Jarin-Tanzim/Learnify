import 'package:flutter/material.dart';
import '../widgets/game_card.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  List<String> getGames() {
    if (title == 'Alphabets') {
      return ['Match Letters', 'Find the Letter', 'Letter Sounds'];
    } else if (title == 'Numbers') {
      return ['Count Objects', 'Find the Number', 'Number Match'];
    } else if (title == 'Colors') {
      return ['Match Colors', 'Find the Color', 'Color Mix'];
    } else if (title == 'Shapes') {
      return ['Match Shapes', 'Find the Shape', 'Shape Puzzle'];
    } else {
      return ['Animal Sounds', 'Find the Sound', 'Sound Match'];
    }
  }

  IconData getCategoryIcon() {
    if (title == 'Alphabets') return Icons.text_fields_rounded;
    if (title == 'Numbers') return Icons.calculate_rounded;
    if (title == 'Colors') return Icons.palette_rounded;
    if (title == 'Shapes') return Icons.category_rounded;
    return Icons.volume_up_rounded;
  }

  String getHeaderTitle() {
    if (title == 'Numbers') return 'Numbers & Counting';
    if (title == 'Colors') return 'Colors & Fun';
    if (title == 'Shapes') return 'Shapes & Patterns';
    return title;
  }

  @override
  Widget build(BuildContext context) {
    final games = getGames();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEAF8FC),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: Color(0xFF0796B8),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFEAF8FC),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: Color(0xFF0796B8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: title == 'Sounds'
                      ? const Color(0xFFFFDCA8)
                      : const Color(0xFFBDEBFF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getHeaderTitle(),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF075E75),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF075E75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      getCategoryIcon(),
                      size: 36,
                      color: const Color(0xFF075E75),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              for (int i = 0; i < games.length; i++)
                GameCard(
                  title: games[i],
                  icon: i == 0
                      ? Icons.star_rounded
                      : i == 1
                          ? Icons.search_rounded
                          : Icons.extension_rounded,
                  iconColor: i == 0
                      ? const Color(0xFF0796B8)
                      : i == 1
                          ? const Color(0xFFC2185B)
                          : const Color(0xFF7A7500),
                  stars: i == 0 ? 2 : 1,
                ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFFFF6C7),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Keep it up!\nTotal Stars 3/9',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF102A43),
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Color(0xFF7A7500),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
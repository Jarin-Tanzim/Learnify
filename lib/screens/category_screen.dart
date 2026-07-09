import 'package:flutter/material.dart';
import '../widgets/game_card.dart';
import '../games/alphabet_game.dart';
import '../games/find_letter_game.dart';
import '../games/letter_sounds_game.dart';
import '../games/count_objects_game.dart';
import '../games/find_number_game.dart';
import '../games/number_order_game.dart';
import '../games/match_colors_game.dart';
import '../games/color_picture_game.dart';
import '../games/color_mix_game.dart';
import '../games/match_shapes_game.dart';
import '../games/shape_builder_game.dart';
import '../games/shape_hunt_game.dart';


class CategoryScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const CategoryScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  List<String> getGames() {
  switch (title) {
    case 'Alphabets':
      return ['Match Letters', 'Find the Letter', 'Letter Sounds'];

    case 'Numbers':
      return ['Count Objects', 'Find the Number', 'Number Order'];

    case 'Colors':
      return ['Match Colors', 'Color the Picture', 'Color Mix'];

    case 'Shapes':
      return ['Match Shapes', 'Shape Detective', 'Shape Hunt'];

    default:
      return [];
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

  void openGame(BuildContext context, int index) {
  if (title == 'Alphabets' && index == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AlphabetGame()),
    );
  } else if (title == 'Alphabets' && index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FindLetterGame()),
    );
  } else if (title == 'Alphabets' && index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LetterSoundsGame()),
    );
  } else if (title == 'Numbers' && index == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CountObjectsGame()),
    );
  } else if (title == 'Numbers' && index == 1) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const FindNumberGame()),
  );
  
}else if (title == 'Numbers' && index == 2) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NumberOrderGame()),
  );
  
}else if (title == 'Colors' && index == 0) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const MatchColorsGame()),
  );
}
else if (title == 'Colors' && index == 1) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ColorPictureGame()),
  );
}
else if (title == 'Colors' && index == 2) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ColorMixGame()),
  );
}
else if (title == 'Shapes' && index == 0) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => MatchShapesGame()),
  );
}
else if (title == 'Shapes' && index == 1) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ShapeBuilderGame(),
    ),
  );
}
else if (title == 'Shapes' && index == 2) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ShapeHuntGame(),
    ),
  );
}
else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This game will be added soon.'),
      ),
    );
  }
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
                  onTap: () => openGame(context, i),
                ),

              
            ],
          ),
        ),
      ),
    );
  }
}

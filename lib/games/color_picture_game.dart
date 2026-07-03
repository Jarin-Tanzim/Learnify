import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ColorPictureGame extends StatefulWidget {
  const ColorPictureGame({super.key});

  @override
  State<ColorPictureGame> createState() => _ColorPictureGameState();
}

class _ColorPictureGameState extends State<ColorPictureGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'emoji': '🍎',
      'question': 'What color should the apple be?',
      'answer': 'Red',
      'options': [
        {'name': 'Red', 'color': Colors.red},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Green', 'color': Colors.green},
      ],
    },
    {
      'emoji': '🍌',
      'question': 'What color should the banana be?',
      'answer': 'Yellow',
      'options': [
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Red', 'color': Colors.red},
      ],
    },
    {
      'emoji': '🌿',
      'question': 'What color should the leaf be?',
      'answer': 'Green',
      'options': [
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Orange', 'color': Colors.orange},
        {'name': 'Pink', 'color': Colors.pink},
        {'name': 'Blue', 'color': Colors.blue},
      ],
    },
    {
      'emoji': '🌊',
      'question': 'What color is the water?',
      'answer': 'Blue',
      'options': [
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Brown', 'color': Colors.brown},
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Red', 'color': Colors.red},
      ],
    },
    {
      'emoji': '🍇',
      'question': 'What color should the grapes be?',
      'answer': 'Purple',
      'options': [
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Blue', 'color': Colors.blue},
      ],
    },
  ];

  int currentQuestion = 0;
  String message = '';
  bool completed = false;
  bool saving = false;

  Future<void> answer(String selected) async {
    if (completed || saving) return;

    if (selected == questions[currentQuestion]['answer']) {
      if (currentQuestion == questions.length - 1) {
        setState(() {
          completed = true;
          saving = true;
          message = 'Excellent! You finished Color the Picture!';
        });

        try {
          await FirestoreService().completeGame('colors');
        } catch (e) {
          debugPrint('Progress update failed: $e');
        }

        if (!mounted) return;

        setState(() {
          saving = false;
        });
      } else {
        setState(() {
          currentQuestion++;
          message = 'Correct!';
        });
      }
    } else {
      setState(() {
        message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    final options = q['options'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFEAF8FC),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF0796B8),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Color the Picture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC6D9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestion + 1} of ${questions.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC2185B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q['emoji'],
                      style: const TextStyle(fontSize: 54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              for (final option in options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: option['color'],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => answer(option['name']),
                      child: Text(
                        option['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: option['name'] == 'Yellow'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              if (saving)
                const CircularProgressIndicator()
              else
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: message == 'Try again!'
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                ),

              const SizedBox(height: 18),

              if (completed)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0796B8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Back to Games',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
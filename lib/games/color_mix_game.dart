import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ColorMixGame extends StatefulWidget {
  const ColorMixGame({super.key});

  @override
  State<ColorMixGame> createState() => _ColorMixGameState();
}

class _ColorMixGameState extends State<ColorMixGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'mix': 'Red + Yellow',
      'answer': 'Orange',
      'leftColor': Colors.red,
      'rightColor': Colors.yellow,
      'options': [
        {'name': 'Orange', 'color': Colors.orange},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Blue', 'color': Colors.blue},
      ],
    },
    {
      'mix': 'Blue + Yellow',
      'answer': 'Green',
      'leftColor': Colors.blue,
      'rightColor': Colors.yellow,
      'options': [
        {'name': 'Red', 'color': Colors.red},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Orange', 'color': Colors.orange},
      ],
    },
    {
      'mix': 'Red + Blue',
      'answer': 'Purple',
      'leftColor': Colors.red,
      'rightColor': Colors.blue,
      'options': [
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Orange', 'color': Colors.orange},
      ],
    },
    {
      'mix': 'White + Red',
      'answer': 'Pink',
      'leftColor': Colors.white,
      'rightColor': Colors.red,
      'options': [
        {'name': 'Pink', 'color': Colors.pink},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Brown', 'color': Colors.brown},
        {'name': 'Green', 'color': Colors.green},
      ],
    },
    {
      'mix': 'Black + White',
      'answer': 'Gray',
      'leftColor': Colors.black,
      'rightColor': Colors.white,
      'options': [
        {'name': 'Red', 'color': Colors.red},
        {'name': 'Gray', 'color': Colors.grey},
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Purple', 'color': Colors.purple},
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
          message = 'Excellent! You finished Color Mix!';
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
                      'Color Mix',
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
                    const SizedBox(height: 12),
                    Text(
                      q['mix'],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        colorCircle(q['leftColor']),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        colorCircle(q['rightColor']),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '= ?',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'What color do they make?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                          color: option['name'] == 'Yellow' ||
                                  option['name'] == 'Gray'
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

  Widget colorCircle(Color color) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
        ),
      ),
    );
  }
}
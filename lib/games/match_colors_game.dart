import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MatchColorsGame extends StatefulWidget {
  const MatchColorsGame({super.key});

  @override
  State<MatchColorsGame> createState() => _MatchColorsGameState();
}

class _MatchColorsGameState extends State<MatchColorsGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Tap the color Red',
      'answer': 'Red',
      'options': [
        {'name': 'Red', 'color': Colors.red},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Yellow', 'color': Colors.yellow},
      ],
    },
    {
      'question': 'Tap the color Blue',
      'answer': 'Blue',
      'options': [
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Orange', 'color': Colors.orange},
        {'name': 'Green', 'color': Colors.green},
      ],
    },
    {
      'question': 'Tap the color Green',
      'answer': 'Green',
      'options': [
        {'name': 'Red', 'color': Colors.red},
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Pink', 'color': Colors.pink},
        {'name': 'Blue', 'color': Colors.blue},
      ],
    },
    {
      'question': 'Tap the color Yellow',
      'answer': 'Yellow',
      'options': [
        {'name': 'Yellow', 'color': Colors.yellow},
        {'name': 'Purple', 'color': Colors.purple},
        {'name': 'Brown', 'color': Colors.brown},
        {'name': 'Blue', 'color': Colors.blue},
      ],
    },
    {
      'question': 'Tap the color Orange',
      'answer': 'Orange',
      'options': [
        {'name': 'Green', 'color': Colors.green},
        {'name': 'Orange', 'color': Colors.orange},
        {'name': 'Pink', 'color': Colors.pink},
        {'name': 'Red', 'color': Colors.red},
      ],
    },
  ];

  int currentQuestion = 0;
  String message = '';
  bool gameCompleted = false;
  bool saving = false;

  Future<void> checkAnswer(String selectedAnswer) async {
    if (gameCompleted || saving) return;

    final correctAnswer = questions[currentQuestion]['answer'];

    if (selectedAnswer == correctAnswer) {
      if (currentQuestion == questions.length - 1) {
        setState(() {
          gameCompleted = true;
          saving = true;
          message = 'Great job! You finished Match Colors!';
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
    final question = questions[currentQuestion];
    final options = question['options'] as List<Map<String, dynamic>>;

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
                      'Match Colors',
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

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC6D9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestion + 1} of ${questions.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC2185B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];

                  return GestureDetector(
                    onTap: () => checkAnswer(option['name']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: option['color'],
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          option['name'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: option['name'] == 'Yellow'
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              if (saving)
                const CircularProgressIndicator()
              else
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: message == 'Try again!'
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                ),

              const SizedBox(height: 24),

              if (gameCompleted)
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
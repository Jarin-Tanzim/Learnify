import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CountObjectsGame extends StatefulWidget {
  const CountObjectsGame({super.key});

  @override
  State<CountObjectsGame> createState() => _CountObjectsGameState();
}

class _CountObjectsGameState extends State<CountObjectsGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'emoji': '🍎',
      'count': 3,
      'options': ['1', '2', '3', '4'],
    },
    {
      'emoji': '⭐',
      'count': 5,
      'options': ['3', '4', '5', '6'],
    },
    {
      'emoji': '🐶',
      'count': 2,
      'options': ['1', '2', '3', '5'],
    },
    {
      'emoji': '🎈',
      'count': 4,
      'options': ['2', '3', '4', '6'],
    },
    {
      'emoji': '🌸',
      'count': 1,
      'options': ['1', '2', '4', '5'],
    },
  ];

  int currentQuestion = 0;
  String message = '';
  bool gameCompleted = false;
  bool saving = false;

  Future<void> checkAnswer(String selectedAnswer) async {
    if (gameCompleted || saving) return;

    final correctAnswer = questions[currentQuestion]['count'].toString();

    if (selectedAnswer == correctAnswer) {
      if (currentQuestion == questions.length - 1) {
        setState(() {
          gameCompleted = true;
          saving = true;
          message = 'Amazing! You finished Count Objects!';
        });

        try {
          await FirestoreService().completeGame('numbers');
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
    final options = question['options'] as List<String>;
    final emoji = question['emoji'] as String;
    final count = question['count'] as int;

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
                      'Count Objects',
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
                  color: const Color(0xFFFFEE70),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestion + 1} of ${questions.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7A7500),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'How many do you see?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        count,
                        (index) => Text(
                          emoji,
                          style: const TextStyle(fontSize: 44),
                        ),
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
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];

                  return GestureDetector(
                    onTap: () => checkAnswer(option),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0796B8),
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
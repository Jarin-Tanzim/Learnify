import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class NumberOrderGame extends StatefulWidget {
  const NumberOrderGame({super.key});

  @override
  State<NumberOrderGame> createState() => _NumberOrderGameState();
}

class _NumberOrderGameState extends State<NumberOrderGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What comes after 2?',
      'display': '1, 2, ?',
      'answer': '3',
      'options': ['3', '4', '5', '6'],
    },
    {
      'question': 'What comes after 4?',
      'display': '3, 4, ?',
      'answer': '5',
      'options': ['2', '5', '7', '9'],
    },
    {
      'question': 'What comes before 8?',
      'display': '?, 8, 9',
      'answer': '7',
      'options': ['5', '6', '7', '9'],
    },
    {
      'question': 'What comes after 6?',
      'display': '5, 6, ?',
      'answer': '7',
      'options': ['6', '7', '8', '9'],
    },
    {
      'question': 'What comes before 4?',
      'display': '?, 4, 5',
      'answer': '3',
      'options': ['1', '2', '3', '6'],
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
          message = 'Awesome! You finished Number Order!';
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
                      'Number Order',
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
                    Text(
                      question['display'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
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
                            fontSize: 46,
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
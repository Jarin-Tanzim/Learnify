import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FindNumberGame extends StatefulWidget {
  const FindNumberGame({super.key});

  @override
  State<FindNumberGame> createState() => _FindNumberGameState();
}

class _FindNumberGameState extends State<FindNumberGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Tap number 5',
      'answer': '5',
      'options': ['2', '5', '7', '9'],
    },
    {
      'question': 'Tap number 2',
      'answer': '2',
      'options': ['1', '2', '4', '6'],
    },
    {
      'question': 'Tap number 8',
      'answer': '8',
      'options': ['3', '6', '8', '9'],
    },
    {
      'question': 'Tap number 1',
      'answer': '1',
      'options': ['1', '5', '7', '0'],
    },
    {
      'question': 'Tap number 4',
      'answer': '4',
      'options': ['2', '3', '4', '8'],
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
          message = 'Great job! You finished Find the Number!';
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
                      'Find the Number',
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
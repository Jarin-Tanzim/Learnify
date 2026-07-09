import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ShapeHuntGame extends StatefulWidget {
  const ShapeHuntGame({super.key});

  @override
  State<ShapeHuntGame> createState() => _ShapeHuntGameState();
}

class _ShapeHuntGameState extends State<ShapeHuntGame> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which object is a circle?',
      'answer': '⚽',
      'options': ['⚽', '🍕', '🎁', '⭐'],
      'labels': ['Ball', 'Pizza Slice', 'Gift Box', 'Star'],
    },
    {
      'question': 'Which object is a triangle?',
      'answer': '🍕',
      'options': ['🍕', '⚽', '🪙', '📺'],
      'labels': ['Pizza Slice', 'Ball', 'Coin', 'TV'],
    },
    {
      'question': 'Which object is a square?',
      'answer': '🪟',
      'options': ['🪟', '🍩', '⚽', '🍕'],
      'labels': ['Window', 'Donut', 'Ball', 'Pizza'],
    },
    {
      'question': 'Which object is a heart?',
      'answer': '❤️',
      'options': ['❤️', '⭐', '⚽', '🪙'],
      'labels': ['Heart', 'Star', 'Ball', 'Coin'],
    },
    {
      'question': 'Which object is a star?',
      'answer': '⭐',
      'options': ['⭐', '🍎', '🎁', '⚽'],
      'labels': ['Star', 'Apple', 'Gift', 'Ball'],
    },
  ];

  int currentQuestion = 0;
  String message = '';
  bool gameCompleted = false;
  bool saving = false;

  Future<void> checkAnswer(String selected) async {
    if (gameCompleted || saving) return;

    final answer = questions[currentQuestion]['answer'];

    if (selected == answer) {
      if (currentQuestion == questions.length - 1) {
        setState(() {
          gameCompleted = true;
          saving = true;
          message = 'Awesome! You finished Shape Hunt!';
        });

        try {
          await FirestoreService().completeGame('shapes');
        } catch (_) {}

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
    final options = q['options'] as List<String>;
    final labels = q['labels'] as List<String>;

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
                      'Shape Hunt',
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
                  color: const Color(0xFFE8EEF2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Text(
                      'Question ${currentQuestion + 1} of ${questions.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      q['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
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
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () => checkAnswer(options[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            color: Colors.black.withOpacity(.06),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            options[index],
                            style: const TextStyle(fontSize: 54),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            labels[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: message == 'Try again!'
                        ? Colors.red
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
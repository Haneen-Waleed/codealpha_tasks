import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Quiz Result'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              score == totalQuestions
                  ? Icons.emoji_events_outlined
                  : Icons.check_circle_outline,
              size: 70,
              color: primary,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              curve: Curves.easeOutBack,
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Score',
              style: TextStyle(
                fontSize: 24,
              ),
            )
                .animate()
                .fadeIn(
              delay: 150.ms,
              duration: 400.ms,
            ),

            const SizedBox(height: 15),

            Text(
              '$score / $totalQuestions',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(
              delay: 250.ms,
              duration: 500.ms,
            )
                .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              curve: Curves.easeOutBack,
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(
              delay: 450.ms,
              duration: 400.ms,
            )
                .slideY(begin: 0.15),
          ],
        ),
      ),
    );
  }
}
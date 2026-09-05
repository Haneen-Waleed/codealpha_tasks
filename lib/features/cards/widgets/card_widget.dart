import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class CardWidget extends StatelessWidget {
  final String question;
  final String answer;

  const CardWidget({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      color: Colors.transparent,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        speed: 800,

        // ================= FRONT SIDE (QUESTION) =================
        front: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Label يوضح إن ده السؤال
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Question',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // نص السؤال
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ================= BACK SIDE (ANSWER) =================
        back: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Label يوضح إن دي الإجابة / المعلومة
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: primary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Answer',
                        style: TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // نص الإجابة
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Text(
                    answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
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
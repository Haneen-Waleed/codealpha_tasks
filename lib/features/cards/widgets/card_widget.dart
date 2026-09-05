import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class CardWidget extends StatefulWidget {
  final String question;
  final String answer;

  const CardWidget({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        speed: 700,

        // ================= FRONT =================
        front: Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Question label
              Positioned(
                top: 18,
                left: 18,
                child: _label(
                  icon: Icons.help_outline_rounded,
                  text: 'Question',
                  background: Colors.white.withOpacity(0.15),
                  foreground: Colors.white,
                ),
              ),

              // Question
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 55, 25, 70),
                  child: Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              // Show Answer Button
              Positioned(
                bottom: 18,
                left: 24,
                right: 24,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cardKey.currentState?.toggleCard();
                    },
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 19,
                    ),
                    label: const Text(
                      'Show Answer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ================= BACK =================
        back: Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primary.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Answer label
              Positioned(
                top: 18,
                left: 18,
                child: _label(
                  icon: Icons.lightbulb_outline_rounded,
                  text: 'Answer',
                  background: primary.withOpacity(0.12),
                  foreground: primary,
                ),
              ),

              // Answer
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 55, 25, 70),
                  child: Text(
                    widget.answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              // Show Question Button
              Positioned(
                bottom: 18,
                left: 24,
                right: 24,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cardKey.currentState?.toggleCard();
                    },
                    icon: const Icon(
                      Icons.replay_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'Show Question',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
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

  Widget _label({
    required IconData icon,
    required String text,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: foreground,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
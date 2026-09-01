import 'package:flash_cards/models/flash_card_model.dart';

class QuizQuestion {
  final Flashcard card;
  final bool? isCorrect;

  const QuizQuestion({
    required this.card,
    this.isCorrect,
  });

  QuizQuestion copyWith({
    bool? isCorrect,
  }) {
    return QuizQuestion(
      card: card,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
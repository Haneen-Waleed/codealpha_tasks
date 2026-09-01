
import '../models/quiz_question_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final Duration remainingTime;
  final bool showHint;

  QuizInProgress({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.remainingTime,
    this.showHint = false,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizInProgress copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    Duration? remainingTime,
    bool? showHint,
  }) {
    return QuizInProgress(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      remainingTime: remainingTime ?? this.remainingTime,
      showHint: showHint ?? this.showHint,
    );
  }
}

class QuizFinished extends QuizState {
  final int score;
  final int totalQuestions;
  final String folderId;

  QuizFinished({
    required this.score,
    required this.totalQuestions,
    required this.folderId,
  });
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}
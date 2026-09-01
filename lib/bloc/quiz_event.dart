import 'package:flash_cards/models/flash_card_model.dart';

abstract class QuizEvent {}

class StartQuizEvent extends QuizEvent {
  final List<Flashcard> cards;
  final Duration duration;
  final String folderId;

  StartQuizEvent({
    required this.cards,
    required this.duration,
    required this.folderId,
  });
}

class CheckAnswerEvent extends QuizEvent {
  final String answer;

  CheckAnswerEvent(this.answer);
}

class NextQuestionEvent extends QuizEvent {}

class ShowHintEvent extends QuizEvent {}

class TimeUpEvent extends QuizEvent {}

class FinishQuizEvent extends QuizEvent {}

class TimerTickEvent extends QuizEvent {}
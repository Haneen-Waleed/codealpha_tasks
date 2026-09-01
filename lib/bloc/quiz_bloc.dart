import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'quiz_event.dart';
import 'quiz_state.dart';
import '../models/quiz_question_model.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  Timer? _timer;

  Duration _remainingTime = Duration.zero;
  String _folderId = '';

  QuizBloc() : super(QuizInitial()) {
    on<StartQuizEvent>(_startQuiz);
    on<CheckAnswerEvent>(_checkAnswer);
    on<NextQuestionEvent>(_nextQuestion);
    on<ShowHintEvent>(_showHint);
    on<TimeUpEvent>(_timeUp);
    on<FinishQuizEvent>(_finishQuiz);
    on<TimerTickEvent>(_timerTick);
  }

  // =========================
  // START QUIZ
  // =========================

  void _startQuiz(StartQuizEvent event, Emitter<QuizState> emit) {
    print('START QUIZ CALLED');
    print('Cards: ${event.cards.length}');
    print('Duration: ${event.duration}');
    print('Folder: ${event.folderId}');

    if (event.cards.isEmpty) {
      emit(QuizError('No flashcards available for this quiz.'));
      return;
    }

    _timer?.cancel();

    _folderId = event.folderId;
    _remainingTime = event.duration;

    final questions = event.cards
        .map((card) => QuizQuestion(card: card))
        .toList();

    questions.shuffle();

    emit(
      QuizInProgress(
        questions: questions,
        currentIndex: 0,
        score: 0,
        remainingTime: _remainingTime,
      ),
    );

    _startTimer();
  }

  // =========================
  // TIMER
  // =========================

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingTime.inSeconds <= 1) {
        _remainingTime = Duration.zero;

        _timer?.cancel();

        add(TimeUpEvent());
        return;
      }

      _remainingTime -= const Duration(seconds: 1);

      add(TimerTickEvent());
    });
  }

  void _timerTick(TimerTickEvent event, Emitter<QuizState> emit) {
    final currentState = state;

    if (currentState is QuizInProgress) {
      emit(currentState.copyWith(remainingTime: _remainingTime));
    }
  }

  // =========================
  // CHECK ANSWER
  // =========================

  void _checkAnswer(CheckAnswerEvent event, Emitter<QuizState> emit) {
    final currentState = state;

    if (currentState is! QuizInProgress) return;

    final currentQuestion = currentState.currentQuestion;

    // Prevent checking the same question twice
    if (currentQuestion.isCorrect != null) return;

    final userAnswer = _normalize(event.answer);
    final correctAnswer = _normalize(currentQuestion.card.answer);

    final isCorrect = userAnswer == correctAnswer;

    final updatedQuestion = currentQuestion.copyWith(isCorrect: isCorrect);

    final updatedQuestions = List<QuizQuestion>.from(currentState.questions);

    updatedQuestions[currentState.currentIndex] = updatedQuestion;

    emit(
      currentState.copyWith(
        questions: updatedQuestions,
        score: isCorrect ? currentState.score + 1 : currentState.score,
      ),
    );
  }

  // =========================
  // NEXT QUESTION
  // =========================

  void _nextQuestion(NextQuestionEvent event, Emitter<QuizState> emit) {
    final currentState = state;

    if (currentState is! QuizInProgress) return;

    // Can't move forward without answering
    if (currentState.currentQuestion.isCorrect == null) {
      return;
    }

    // Last question
    if (currentState.isLastQuestion) {
      add(FinishQuizEvent());
      return;
    }

    emit(
      currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
        showHint: false,
      ),
    );
  }

  // =========================
  // SHOW HINT
  // =========================

  void _showHint(ShowHintEvent event, Emitter<QuizState> emit) {
    final currentState = state;

    if (currentState is QuizInProgress) {
      emit(currentState.copyWith(showHint: true));
    }
  }

  // =========================
  // TIME UP
  // =========================

  Future<void> _timeUp(TimeUpEvent event, Emitter<QuizState> emit) async {
    print('⏰ TIME IS UP');

    final currentState = state;

    if (currentState is! QuizInProgress) {
      return;
    }

    await _finishQuiz(event, emit);
  }

  // =========================
  // FINISH QUIZ
  // =========================

  Future<void> _finishQuiz(QuizEvent event, Emitter<QuizState> emit) async {
    print('🔥 FINISH QUIZ CALLED');

    final currentState = state;

    if (currentState is! QuizInProgress) {
      print('❌ State is NOT QuizInProgress');
      return;
    }

    print('✅ Current score: ${currentState.score}');

    _timer?.cancel();

    // Unanswered questions are considered wrong.
    final updatedQuestions = List<QuizQuestion>.from(currentState.questions);

    for (int i = 0; i < updatedQuestions.length; i++) {
      if (updatedQuestions[i].isCorrect == null) {
        updatedQuestions[i] = updatedQuestions[i].copyWith(isCorrect: false);
      }
    }
    final result = {
    'score': currentState.score,
    'folderId': _folderId,
    'totalQuestions': currentState.questions.length,
    'date': DateTime.now().toIso8601String(),
    };
    try {
      final box = Hive.box('QuizResults');

      print('📦 Hive box opened');

      await box.add(result);

      print('✅ Result saved');

      emit(
        QuizFinished(
          score: currentState.score,
          totalQuestions: currentState.questions.length,
          folderId: _folderId,
        ),
      );

      print('🎉 QuizFinished emitted');
    } catch (e, stackTrace) {
      print('❌ FINISH ERROR: $e');
      print(stackTrace);

      emit(QuizError(e.toString()));
    }
  }

  // =========================
  // NORMALIZE ANSWER
  // =========================

  String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  // =========================
  // CLOSE
  // =========================

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

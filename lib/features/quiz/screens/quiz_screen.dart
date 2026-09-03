import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/core/custome_widgets/custom_button.dart';
import 'package:flash_cards/features/quiz/screens/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../bloc/quiz_bloc.dart';
import '../../../bloc/quiz_event.dart';
import '../../../bloc/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController answerController = TextEditingController();

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is QuizInProgress) {
          return _buildQuiz(context, state);
        }

        if (state is QuizFinished) {
          return QuizResultScreen(
            score: state.score,
            totalQuestions: state.totalQuestions,
          );
        }

        if (state is QuizError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(state.message)),
          );
        }

        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildQuiz(BuildContext context, QuizInProgress state) {
    final question = state.currentQuestion;

    final minutes = state.remainingTime.inMinutes.toString().padLeft(2, '0');

    final seconds = state.remainingTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final isAnswered = question.isCorrect != null;

    final progress = (state.currentIndex + 1) / state.questions.length;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '$minutes:$seconds',
          style: TextStyle(
            color: state.remainingTime.inSeconds <= 30
                ? Colors.red
                : Colors.grey.shade800,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 5, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.currentIndex + 1} / ${state.questions.length}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 42),

                Text(
                  'Question',
                  style: TextStyle(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 350.ms)
                    .slideX(begin: -0.08),

                const SizedBox(height: 10),

                Text(
                  question.card.question,
                  style: const TextStyle(
                    fontSize: 25,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                )
                    .animate(key: ValueKey(state.currentIndex))
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.08),

                const SizedBox(height: 28),

                TextField(
                  controller: answerController,
                  enabled: !isAnswered,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Your answer',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(17),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                )
                    .animate(key: ValueKey('answer_${state.currentIndex}'))
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1),

                if (question.card.hint.isNotEmpty && !state.showHint) ...[
                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: isAnswered
                        ? null
                        : () {
                      context.read<QuizBloc>().add(ShowHintEvent());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: primary,
                    ),
                    child: const Text(
                      'Need a hint?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideX(begin: -0.05),
                ],

                if (state.showHint) ...[
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 20,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            question.card.hint,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.05),
                ],

                if (isAnswered) ...[
                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: question.isCorrect!
                          ? Colors.green.withOpacity(0.08)
                          : Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      question.isCorrect!
                          ? 'Correct!'
                          : 'Correct answer: ${question.card.answer}',
                      style: TextStyle(
                        color: question.isCorrect!
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .scale(
                    begin: const Offset(0.97, 0.97),
                    end: const Offset(1, 1),
                  ),
                ],

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: CustomButton(
                    onPressed: () {
                      if (!isAnswered) {
                        if (answerController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Write your answer first.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          return;
                        }

                        context.read<QuizBloc>().add(
                          CheckAnswerEvent(answerController.text),
                        );
                      } else {
                        context.read<QuizBloc>().add(
                          NextQuestionEvent(),
                        );

                        answerController.clear();
                      }
                    },
                    text: isAnswered
                        ? (state.isLastQuestion ? 'Finish' : 'Next')
                        : 'Check answer',
                  ),
                )
                    .animate(key: ValueKey('button_${state.currentIndex}'))
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.15),
              ],
            ),
          ),
        ),
    );
  }
}

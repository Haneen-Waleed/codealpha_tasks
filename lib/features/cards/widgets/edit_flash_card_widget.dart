import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/core/custome_widgets/helpers.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> dialogBuilderEdit(
    BuildContext context,
    int index,
    Flashcard card,
    ) async {
  await showDialog(
    context: context,
    builder: (_) {
      return _EditFlashCardDialog(
        index: index,
        card: card,
        parentContext: context,
      );
    },
  );
}

class _EditFlashCardDialog extends StatefulWidget {
  final int index;
  final Flashcard card;
  final BuildContext parentContext;

  const _EditFlashCardDialog({
    required this.index,
    required this.card,
    required this.parentContext,
  });

  @override
  State<_EditFlashCardDialog> createState() =>
      _EditFlashCardDialogState();
}

class _EditFlashCardDialogState
    extends State<_EditFlashCardDialog> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;
  late final TextEditingController hintController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(
      text: widget.card.question,
    );

    answerController = TextEditingController(
      text: widget.card.answer,
    );

    hintController = TextEditingController(
      text: widget.card.hint,
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    hintController.dispose();

    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: primary,
      ),
      filled: true,
      fillColor: lightGrey,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: red,
        ),
      ),
    );
  }

  void updateFlashCard() {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final Flashcard updatedCard = Flashcard(
      question: questionController.text.trim(),
      answer: answerController.text.trim(),
      hint: hintController.text.trim(),
      folderId: widget.card.folderId,
    );

    widget.parentContext
        .read<FlashCardsBloc>()
        .add(
      EditFlashCardEvent(
        widget.index,
        updatedCard,
      ),
    );

    Navigator.pop(context);

    Helpers().snackBar(
      widget.parentContext,
      text: 'FlashCard updated successfully',
      color: green,
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom;

    return AlertDialog(
      backgroundColor: background,
      elevation: 15,

      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),

      title: Center(
        child: Text(
          'Edit FlashCard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
      ),

      content: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom: keyboardHeight > 0 ? 8 : 0,
        ),
        child: SizedBox(
          width: 330,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionController,
                    textInputAction:
                    TextInputAction.next,
                    maxLines: null,
                    decoration: inputDecoration(
                      hint: 'Question',
                      icon: Icons.question_mark,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Question can't be empty";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: answerController,
                    textInputAction:
                    TextInputAction.next,
                    maxLines: null,
                    decoration: inputDecoration(
                      hint: 'Answer',
                      icon: Icons.notes,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Answer can't be empty";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: hintController,
                    textInputAction:
                    TextInputAction.done,
                    maxLines: null,
                    decoration: inputDecoration(
                      hint: 'Hint',
                      icon: Icons.lightbulb,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),

      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: primary,
              fontSize: 16,
            ),
          ),
        ),

        SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: background,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: updateFlashCard,
            child: const Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
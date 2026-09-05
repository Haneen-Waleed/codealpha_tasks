import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/custome_widgets/helpers.dart';
import '../../../models/flash_card_model.dart';

Future<void> dialogBuilderEdit(
    BuildContext context,
    int index,
    Flashcard card,
    ) {
  final TextEditingController question =
  TextEditingController(text: card.question);

  final TextEditingController answer =
  TextEditingController(text: card.answer);

  final TextEditingController hint =
  TextEditingController(text: card.hint);

  final formKey = GlobalKey<FormState>();

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

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: background,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),

        title: Center(
          child: Text(
            "Edit FlashCard",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ),

        content: SizedBox(
          width: 330,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: question,
                  decoration: inputDecoration(
                    hint: "Question",
                    icon: Icons.question_mark,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Question can't be empty";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: answer,
                  decoration: inputDecoration(
                    hint: "Answer",
                    icon: Icons.notes,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Answer can't be empty";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: hint,
                  decoration: inputDecoration(
                    hint: "Hint",
                    icon: Icons.lightbulb,
                  ),
                ),
              ],
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
              Navigator.pop(dialogContext);
            },
            child: Text(
              "Cancel",
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final Flashcard updatedCard = Flashcard(
                    question: question.text.trim(),
                    answer: answer.text.trim(),
                    hint: hint.text.trim(),

                    // Keep the same folder
                    folderId: card.folderId,
                  );

                  context.read<FlashCardsBloc>().add(
                    EditFlashCardEvent(
                      index,
                      updatedCard,
                    ),
                  );

                  Navigator.pop(dialogContext);

                  Helpers().snackBar(context, text: 'FlashCard updated successfully', color: green);

                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
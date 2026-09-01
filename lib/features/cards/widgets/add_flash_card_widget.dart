import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> dialogBuilder(BuildContext context) {
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController();
  final TextEditingController hint = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final foldersBox = Hive.box('Folders');

  String? selectedFolderId;

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
      fillColor: Colors.grey.shade100,
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
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),

            title: Center(
              child: Text(
                "New FlashCard",
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
                    // Folder
                  DropdownMenu<String>(
                  width: 330,
                  initialSelection: selectedFolderId,

                  hintText: "Select Folder",

                  leadingIcon: Icon(
                    Icons.folder_outlined,
                    color: primary,
                  ),

                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: primary,
                  ),

                  selectedTrailingIcon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: primary,
                  ),

                  textStyle: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),

                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.grey.shade100,

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),

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
                        width: 2,
                      ),
                    ),
                  ),

                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),

                    elevation: const WidgetStatePropertyAll(8),

                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),

                  dropdownMenuEntries: foldersBox.values.map((folder) {
                    final item = Map<String, dynamic>.from(folder);

                    return DropdownMenuEntry<String>(
                      value: item['Id'],
                      label: item['Title'],
                      leadingIcon: Icon(
                        Icons.folder_rounded,
                        color: primary.withOpacity(0.7),
                      ),
                    );
                  }).toList(),

                  onSelected: (value) {
                    setState(() {
                      selectedFolderId = value;
                    });
                  },
                ),

                    const SizedBox(height: 18),

                    // Question
                    TextFormField(
                      controller: question,
                      decoration: inputDecoration(
                        hint: "Question",
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

                    // Answer
                    TextFormField(
                      controller: answer,
                      decoration: inputDecoration(
                        hint: "Answer",
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

                    // Hint
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
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final Flashcard card = Flashcard(
                        question: question.text.trim(),
                        answer: answer.text.trim(),
                        hint: hint.text.trim(),
                        folderId: selectedFolderId!,
                      );

                      context
                          .read<FlashCardsBloc>()
                          .add(AddFlashCardEvent(card));

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: const Center(
                            child: Text(
                              "Flashcard added successfully",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Done",
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
    },
  );
}
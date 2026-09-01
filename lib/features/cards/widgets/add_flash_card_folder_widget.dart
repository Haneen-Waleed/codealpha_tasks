import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/bloc/flash_cards_state.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
Future<void> dialogBuilderFolder(BuildContext context) {
  final TextEditingController title = TextEditingController();

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
        borderSide:  BorderSide(
          color: primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:  BorderSide(
          color: red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:  BorderSide(
          color: red,
        ),
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),

        title:  Center(
          child: Text(
            "New Folder",
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
                  controller: title,
                  decoration: inputDecoration(
                    hint: "Title",
                    icon: Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title can't be empty";
                    }
                    return null;
                  },
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
              Navigator.pop(context);
            },
            child:  Text(
              "Cancel",
              style: TextStyle(
                color: primary,
                fontSize: 16,
              ),
            ),
          ),

          BlocBuilder<FlashCardFolderBloc, FlashCardFolderState>(
            builder: (context, state) {
              return SizedBox(
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
                      Navigator.pop(context);
                      Folder folder=Folder(id: const Uuid().v4(), name: title.text);
                      context.read<FlashCardFolderBloc>().add(AddFlashCardFolderEvent(folder));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          content: const Center(
                            child: Text(
                              "Folder Created successfully",
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
              );
            },
          ),
        ],
      );
    },
  );
}
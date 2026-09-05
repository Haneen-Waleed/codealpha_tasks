
import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/bloc/flash_cards_state.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/core/custome_widgets/helpers.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/flash_card_model.dart';

Future<void> dialogBuilderEditFolder(
    BuildContext context,
    int index,
    String titlee
    ) {
  final TextEditingController title = TextEditingController(text: titlee);


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
            "Edit Folder",
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

                const SizedBox(height: 18),
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
                      context.read<FlashCardFolderBloc>().add(EditFlashCardFolderEvent(index,title.text));
                      Helpers().snackBar(context, text: 'Folder updated successfully', color: green);
                    }
                  },
                  child: const Text(
                    "Save",
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
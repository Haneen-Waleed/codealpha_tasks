import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/core/custome_widgets/helpers.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
Future<void> dialogBuilder(
    BuildContext context, {
      String? folderId,
    }) async {
  final foldersBox = Hive.box('Folders');

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

  await showDialog(
    context: context,
    builder: (dialogContext) {
      // Move controllers inside the StatefulWidget or handle lifecycle safely
      return _FlashCardDialogContent(
        folderId: folderId,
        foldersBox: foldersBox,
        inputDecoration: inputDecoration,
        parentContext: context,
      );
    },
  );
}

class _FlashCardDialogContent extends StatefulWidget {
  final String? folderId;
  final Box foldersBox;
  final InputDecoration Function({required String hint, required IconData icon}) inputDecoration;
  final BuildContext parentContext;

  const _FlashCardDialogContent({
    required this.folderId,
    required this.foldersBox,
    required this.inputDecoration,
    required this.parentContext,
  });

  @override
  State<_FlashCardDialogContent> createState() => _FlashCardDialogContentState();
}

class _FlashCardDialogContentState extends State<_FlashCardDialogContent> {
  late final TextEditingController question;
  late final TextEditingController answer;
  late final TextEditingController hint;
  final formKey = GlobalKey<FormState>();

  String? selectedFolderId;

  @override
  void initState() {
    super.initState();
    question = TextEditingController();
    answer = TextEditingController();
    hint = TextEditingController();
    selectedFolderId = widget.folderId;
  }

  @override
  void dispose() {
    question.dispose();
    answer.dispose();
    hint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedFolderName = 'Select Folder';

    if (selectedFolderId != null) {
      for (final folder in widget.foldersBox.values) {
        final item = Map<String, dynamic>.from(folder);
        if (item['Id'].toString() == selectedFolderId) {
          selectedFolderName = item['Title'].toString();
          break;
        }
      }
    }

    return AlertDialog(
      backgroundColor: background,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final String? result = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: background,
                      isScrollControlled: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (bottomSheetContext) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Select Folder',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.foldersBox.length,
                                    itemBuilder: (context, index) {
                                      final item = Map<String, dynamic>.from(
                                        widget.foldersBox.getAt(index),
                                      );
                                      final String id = item['Id'].toString();
                                      final String title = item['Title'].toString();
                                      final bool isSelected = id == selectedFolderId;

                                      return ListTile(
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 2,
                                        ),
                                        leading: Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.folder_rounded,
                                            color: primary,
                                          ),
                                        ),
                                        title: Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        trailing: isSelected
                                            ? Icon(Icons.check_rounded, color: primary)
                                            : null,
                                        onTap: () {
                                          Navigator.pop(bottomSheetContext, id);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    if (result != null) {
                      setState(() {
                        selectedFolderId = result;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_outlined, color: primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            selectedFolderName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selectedFolderId == null
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade800,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: question,
                  decoration: widget.inputDecoration(
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
                  decoration: widget.inputDecoration(
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
                  decoration: widget.inputDecoration(
                    hint: "Hint",
                    icon: Icons.lightbulb,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: primary, fontSize: 16),
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
              if (selectedFolderId == null || selectedFolderId!.isEmpty) {
                Helpers().snackBar(context, text: 'Please select a folder', color: red);
                return;
              }

              if (!formKey.currentState!.validate()) {
                return;
              }

              final Flashcard card = Flashcard(
                question: question.text.trim(),
                answer: answer.text.trim(),
                hint: hint.text.trim(),
                folderId: selectedFolderId!,
              );

              widget.parentContext.read<FlashCardsBloc>().add(
                AddFlashCardEvent(card),
              );

              Navigator.pop(context);

             Helpers().snackBar(context, text: "FlashCard Added Successfully", color: green);
            },
            child: const Text(
              "Done",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
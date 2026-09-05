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
    builder: (_) {
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
  final InputDecoration Function({
  required String hint,
  required IconData icon,
  }) inputDecoration;
  final BuildContext parentContext;

  const _FlashCardDialogContent({
    required this.folderId,
    required this.foldersBox,
    required this.inputDecoration,
    required this.parentContext,
  });

  @override
  State<_FlashCardDialogContent> createState() =>
      _FlashCardDialogContentState();
}

class _FlashCardDialogContentState extends State<_FlashCardDialogContent> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;
  late final TextEditingController hintController;

  final formKey = GlobalKey<FormState>();

  String? selectedFolderId;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController();
    answerController = TextEditingController();
    hintController = TextEditingController();

    selectedFolderId = widget.folderId;
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    hintController.dispose();

    super.dispose();
  }

  String getSelectedFolderName() {
    if (selectedFolderId == null) {
      return 'Select Folder';
    }

    for (final folder in widget.foldersBox.values) {
      final item = Map<String, dynamic>.from(folder);

      if (item['Id'].toString() == selectedFolderId) {
        return item['Title'].toString();
      }
    }

    return 'Select Folder';
  }

  Future<void> selectFolder() async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 12,
            ),
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
                      final rawItem = widget.foldersBox.getAt(index);

                      if (rawItem == null) {
                        return const SizedBox.shrink();
                      }

                      final item =
                      Map<String, dynamic>.from(rawItem);

                      final String id =
                      item['Id'].toString();

                      final String title =
                      item['Title'].toString();

                      final bool isSelected =
                          id == selectedFolderId;

                      return ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius:
                            BorderRadius.circular(12),
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
                            ? Icon(
                          Icons.check_rounded,
                          color: primary,
                        )
                            : null,
                        onTap: () {
                          Navigator.pop(
                            bottomSheetContext,
                            id,
                          );
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

    if (!mounted) return;

    if (result != null) {
      setState(() {
        selectedFolderId = result;
      });
    }
  }

  Future<void> addFlashCard() async {
    FocusScope.of(context).unfocus();

    if (selectedFolderId == null ||
        selectedFolderId!.isEmpty) {
      Helpers().snackBar(
        context,
        text: 'Please select a folder',
        color: red,
      );
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    final Flashcard card = Flashcard(
      question: questionController.text.trim(),
      answer: answerController.text.trim(),
      hint: hintController.text.trim(),
      folderId: selectedFolderId!,
    );

    widget.parentContext
        .read<FlashCardsBloc>()
        .add(
      AddFlashCardEvent(card),
    );

    Navigator.pop(context);

    Helpers().snackBar(
      widget.parentContext,
      text: 'FlashCard Added Successfully',
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
          'New FlashCard',
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
                  GestureDetector(
                    onTap: selectFolder,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder_outlined,
                            color: primary,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              getSelectedFolderName(),
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                selectedFolderId == null
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade800,
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ),

                          Icon(
                            Icons
                                .keyboard_arrow_down_rounded,
                            color: primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: questionController,
                    textInputAction:
                    TextInputAction.next,
                    maxLines: null,
                    decoration:
                    widget.inputDecoration(
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
                    decoration:
                    widget.inputDecoration(
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
                    decoration:
                    widget.inputDecoration(
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
            onPressed: addFlashCard,
            child: const Text(
              'Done',
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
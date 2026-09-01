import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/features/cards/widgets/edit_flash_card_folder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flash_cards/core/colors.dart';
import '../../../models/folder_model.dart';
import '../screens/folder_cards_screen.dart';

class FolderWidget extends StatelessWidget {
  final Folder folder;
  final int index;

  const FolderWidget({
    super.key,
    required this.folder,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final flashCardsBox = Hive.box('FlashCards');
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FolderCardsScreen(
                folder: folder,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              // Folder icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.folder_outlined,
                  color: primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              // Folder name + card count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu
              PopupMenuButton<String>(
                color: Colors.white,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade500,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    dialogBuilderEditFolder(
                      context,
                      index,
                      folder.name,
                    );
                  }

                  if (value == 'delete') {
                    _deleteFolder(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: red,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(color: red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 4),

              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFolder(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete folder?'),
          content: Text(
            'Are you sure you want to delete "${folder.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context
          .read<FlashCardFolderBloc>()
          .add(DeleteFlashCardFolderEvent(index));
    }
  }
}
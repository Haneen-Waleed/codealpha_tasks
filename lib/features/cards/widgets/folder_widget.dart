import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/features/cards/widgets/edit_flash_card_folder_widget.dart';
import 'package:flash_cards/features/cards/widgets/edit_flash_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/folder_model.dart';
import '../screens/folder_cards_screen.dart';
class FolderWidget extends StatelessWidget {
  final Folder folder;
  final int index;

  const FolderWidget({
    super.key,
    required this.folder, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      color: Colors.white,
      child: BlocBuilder<FlashCardFolderBloc, FlashCardFolderState>(
        builder: (context, state) {
          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FolderCardsScreen(
                      folder: folder,
                    ),
                  ),
                );
              },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: primary,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folder.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        dialogBuilderEditFolder(context, index, folder.name);
                      } else if (value == 'delete') {
                         context.read<FlashCardFolderBloc>().add(DeleteFlashCardFolderEvent(index));
                      }
                    },
                    itemBuilder: (context) =>
                    const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 10),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 10),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
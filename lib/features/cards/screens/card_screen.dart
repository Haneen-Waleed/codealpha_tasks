import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/features/cards/widgets/add_flash_card_folder_widget.dart';
import 'package:flash_cards/features/cards/widgets/folder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/colors.dart';
import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';
import '../../../models/folder_model.dart';
import '../widgets/add_flash_card_widget.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foldersBox = Hive.box('Folders');

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'My Folders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            elevation: 4,
            color: Colors.white,
            icon: Icon(
              Icons.add,
              color: primary,
              size: 28,
            ),
            onSelected: (value) {
              if (value == 'folder') {
                dialogBuilderFolder(context);
              }

              if (value == 'card') {
                if (foldersBox.isNotEmpty) {
                  dialogBuilder(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: const Text(
                        'Create a folder first',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'folder',
                child: Row(
                  children: [
                    Icon(Icons.create_new_folder_outlined),
                    SizedBox(width: 12),
                    Text('New Folder'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'card',
                child: Row(
                  children: [
                    Icon(Icons.style_outlined),
                    SizedBox(width: 12),
                    Text('New Card'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
        ],
      ),

      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 1,
      ),

      body: BlocBuilder<FlashCardFolderBloc, FlashCardFolderState>(
        builder: (context, state) {
          if (foldersBox.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Text(
                      '${foldersBox.length} folders',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        _deleteAllFolders(context);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.grey.shade600,
                        size: 21,
                      ),
                      tooltip: 'Delete all',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: foldersBox.length,
                  itemBuilder: (context, index) {
                    final item = Map<String, dynamic>.from(
                      foldersBox.getAt(index),
                    );

                    final folder = Folder(
                      id: item['Id'],
                      name: item['Title'],
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FolderWidget(
                        folder: folder,
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 56,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 16),

            const Text(
              'No folders yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Create a folder to start organizing your flashcards.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            TextButton.icon(
              onPressed: () {
                dialogBuilderFolder(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create folder'),
              style: TextButton.styleFrom(
                foregroundColor: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAllFolders(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete all folders?'),
          content: const Text(
            'All folders will be permanently deleted.',
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
          .add(DeleteAllFlashCardFolderEvent());
    }
  }
}
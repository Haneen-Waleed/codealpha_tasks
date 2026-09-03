import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/features/cards/widgets/add_flash_card_folder_widget.dart';
import 'package:flash_cards/features/cards/widgets/folder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
            letterSpacing: -0.5,
          ),
        )
            .animate()
            .fadeIn(
          duration: 450.ms,
        )
            .slideX(
          begin: -0.12,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        ),

        actions: [
          PopupMenuButton<String>(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            icon: Icon(
              Icons.add_rounded,
              color: primary,
              size: 29,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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
          )
              .animate()
              .fadeIn(
            delay: 150.ms,
            duration: 400.ms,
          )
              .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            delay: 150.ms,
            duration: 400.ms,
            curve: Curves.easeOutBack,
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

              // Folder count
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  16,
                ),
                child: Row(
                  children: [
                    Text(
                      '${foldersBox.length} folders',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                        .animate()
                        .fadeIn(
                      delay: 150.ms,
                      duration: 400.ms,
                    )
                        .slideX(
                      begin: -0.06,
                      end: 0,
                      delay: 150.ms,
                      duration: 400.ms,
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        _deleteAllFolders(context);
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.grey.shade600,
                        size: 21,
                      ),
                      tooltip: 'Delete all',
                    )
                        .animate()
                        .fadeIn(
                      delay: 250.ms,
                      duration: 400.ms,
                    )
                        .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      delay: 250.ms,
                      duration: 400.ms,
                    ),
                  ],
                ),
              ),

              // Folders
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
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

                    final delay = 250 + (index * 80);

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: FolderWidget(
                        folder: folder,
                        index: index,
                      )
                          .animate()
                          .fadeIn(
                        delay: delay.ms,
                        duration: 400.ms,
                      )
                          .slideY(
                        begin: 0.08,
                        end: 0,
                        delay: delay.ms,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Visual
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 50,
                color: primary.withOpacity(0.65),
              ),
            )
                .animate(
              onPlay: (controller) {
                controller.repeat(
                  reverse: true,
                );
              },
            )
                .moveY(
              begin: -4,
              end: 4,
              duration: 1600.ms,
              curve: Curves.easeInOut,
            ),

            const SizedBox(height: 24),

            const Text(
              'No folders yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            )
                .animate()
                .fadeIn(
              duration: 450.ms,
            )
                .slideY(
              begin: 0.08,
              end: 0,
              duration: 450.ms,
            ),

            const SizedBox(height: 8),

            Text(
              'Create a folder to start organizing\nyour flashcards.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                height: 1.5,
              ),
            )
                .animate()
                .fadeIn(
              delay: 120.ms,
              duration: 450.ms,
            ),

            const SizedBox(height: 22),

            TextButton.icon(
              onPressed: () {
                dialogBuilderFolder(context);
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 19,
              ),
              label: const Text(
                'Create folder',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: primary,
              ),
            )
                .animate()
                .fadeIn(
              delay: 220.ms,
              duration: 450.ms,
            )
                .slideY(
              begin: 0.12,
              end: 0,
              delay: 220.ms,
              duration: 450.ms,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAllFolders(
      BuildContext context,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: const Text(
            'Delete all folders?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          content: const Text(
            'All folders will be permanently deleted.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: primary,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context
          .read<FlashCardFolderBloc>()
          .add(
        DeleteAllFlashCardFolderEvent(),
      );
    }
  }
}
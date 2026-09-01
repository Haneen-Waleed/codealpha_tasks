import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/features/cards/widgets/add_flash_card_folder_widget.dart';
import 'package:flash_cards/features/cards/widgets/folder_widget.dart';
import 'package:flutter/material.dart';

import '../../../bloc/flash_cards_bloc.dart';
import '../../../bloc/flash_cards_event.dart';
import '../../../core/colors.dart';
import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';
import '../../../models/folder_model.dart';
import '../widgets/add_flash_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myBox1 = Hive.box('Folders');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Card'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(Icons.add),
            ),
            onSelected: (value) {
              if (value == 'folder') {
                dialogBuilderFolder(context);
              } else if (value == 'card') {
                if(myBox1.isNotEmpty){
                  dialogBuilder(context);
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.yellow.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content:  Center(
                        child: Text(
                          "You must create folder first",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'folder',
                child: ListTile(
                  leading: Icon(Icons.folder_outlined),
                  title: Text('Create Folder'),
                ),
              ),
              const PopupMenuItem(
                value: 'card',
                child: ListTile(
                  leading: Icon(Icons.style_outlined),
                  title: Text('Create Card'),
                ),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1,),
      body: BlocBuilder<FlashCardFolderBloc, FlashCardFolderState>(
        builder: (context, state) {
          if (myBox1.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Folders Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap + to create your first Folder",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myBox1.length + 1,
            itemBuilder: (context, index) {
              // Header
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.style_outlined,
                        color: Colors.blue.shade900,
                      ),
                      const SizedBox(width: 8),

                      const Text(
                        "Available Folders",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        tooltip: "Delete All",
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete all folders?'),
                                content: const Text(
                                  'Are you sure you want to delete all folders? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child:  Text('Cancel',style: TextStyle(color: primary,fontSize: 16),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child:  Text('Delete',style: TextStyle(color: red,fontSize: 16)),
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
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                );
              }

              //folder
              final folderIndex = index - 1;

              final item = Map<String, dynamic>.from(
                myBox1.getAt(folderIndex),
              );

              final folder = Folder(
                id: item['Id'],
                name: item['Title'],
              );

              return FolderWidget(
                folder: folder,
                index: folderIndex,
              );  },
          );
        },
      ),
    );
  }
}

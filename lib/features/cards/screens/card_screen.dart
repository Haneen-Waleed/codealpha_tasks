import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            onSelected: (value) {
              if (value == 'folder') {
                // Open Create Folder
              } else if (value == 'card') {
                // Open Create Card
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
      backgroundColor: background,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1,),
      body: Center(child: Text('Card'),),
    );
  }
}

import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flash_cards/core/colors.dart';
import '../../../cubit/user_cubit.dart';
import '../../home/screens/home_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    final foldersBox = Hive.box('Folders');
    final cardsBox = Hive.box('FlashCards');

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: foldersBox.listenable(),
          builder: (context, Box box, _) {
            final folderList = box.values.toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Custom Bar
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WELCOME BACK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userState.name.isEmpty ? 'Student' : userState.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>  ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: primary.withOpacity(0.1),
                            child: Text(
                              userState.name.isNotEmpty
                                  ? userState.name[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Statistics Row
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          _buildStatItem(
                            label: 'Total Folders',
                            value: '${folderList.length}',
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          _buildStatItem(
                            label: 'Total Cards',
                            value: '${cardsBox.length}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Title
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Your Decks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                // Folder List
                if (folderList.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(40),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'No decks created yet.\nCreate one from the navigation bar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final folderData = Map<String, dynamic>.from(
                            folderList[index],
                          );
                          final String folderId =
                              folderData['Id']?.toString() ?? '';
                          final String folderTitle =
                              folderData['Title']?.toString() ?? 'Untitled';

                          final cardCount = cardsBox.values.where((item) {
                            final card = Map<String, dynamic>.from(item);
                            return card['FolderId']?.toString() == folderId;
                          }).length;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.folder_open_rounded,
                                    color: primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        folderTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$cardCount cards',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: folderList.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
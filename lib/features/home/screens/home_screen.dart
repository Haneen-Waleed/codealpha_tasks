import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../cubit/user_cubit.dart';
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

      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 0,
      ),

      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: foldersBox.listenable(),

          builder: (context, Box box, _) {
            final folderList = box.values.toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),

              slivers: [

                // --------------------------------------------------
                // Header
                // --------------------------------------------------

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    20,
                    24,
                    12,
                  ),

                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              'WELCOME BACK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.grey.shade500,
                              ),
                            )
                                .animate()
                                .fadeIn(
                              duration: 400.ms,
                            )
                                .slideX(
                              begin: -0.08,
                              end: 0,
                              duration: 400.ms,
                            ),

                            const SizedBox(height: 3),

                            Text(
                              userState.name.isEmpty
                                  ? 'Student'
                                  : userState.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                            )
                                .animate()
                                .fadeIn(
                              delay: 100.ms,
                              duration: 450.ms,
                            )
                                .slideX(
                              begin: -0.1,
                              end: 0,
                              delay: 100.ms,
                              duration: 450.ms,
                              curve: Curves.easeOutCubic,
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const ProfileScreen(),
                              ),
                            );
                          },

                          child: CircleAvatar(
                            radius: 22,

                            backgroundColor:
                            primary.withOpacity(0.1),

                            child: Text(
                              userState.name.isNotEmpty
                                  ? userState.name[0]
                                  .toUpperCase()
                                  : 'U',

                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(
                          delay: 200.ms,
                          duration: 400.ms,
                        )
                            .scale(
                          begin: const Offset(
                            0.75,
                            0.75,
                          ),
                          end: const Offset(
                            1,
                            1,
                          ),
                          delay: 200.ms,
                          duration: 450.ms,
                          curve: Curves.easeOutBack,
                        ),
                      ],
                    ),
                  ),
                ),

                // --------------------------------------------------
                // Statistics
                // --------------------------------------------------

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),

                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius:
                        BorderRadius.circular(20),

                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
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
                    )
                        .animate()
                        .fadeIn(
                      delay: 250.ms,
                      duration: 450.ms,
                    )
                        .slideY(
                      begin: 0.08,
                      end: 0,
                      delay: 250.ms,
                      duration: 450.ms,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),

                // --------------------------------------------------
                // Folders Title
                // --------------------------------------------------

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    22,
                    24,
                    12,
                  ),

                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Your Folders',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: Colors.black87,
                      ),
                    )
                        .animate()
                        .fadeIn(
                      delay: 350.ms,
                      duration: 400.ms,
                    )
                        .slideX(
                      begin: -0.06,
                      end: 0,
                      delay: 350.ms,
                      duration: 400.ms,
                    ),
                  ),
                ),

                // --------------------------------------------------
                // Empty State
                // --------------------------------------------------

                if (folderList.isEmpty)

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      40,
                      35,
                      40,
                      40,
                    ),

                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [

                          Container(
                            width: 80,
                            height: 80,

                            decoration: BoxDecoration(
                              color:
                              primary.withOpacity(0.07),
                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.folder_open_outlined,
                              size: 38,
                              color:
                              primary.withOpacity(0.65),
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
                            begin: -3,
                            end: 3,
                            duration: 1600.ms,
                            curve: Curves.easeInOut,
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'No folders yet',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                              .animate()
                              .fadeIn(
                            delay: 150.ms,
                            duration: 400.ms,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Create a folder to start\norganizing your flashcards.',
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          )
                              .animate()
                              .fadeIn(
                            delay: 220.ms,
                            duration: 400.ms,
                          ),
                        ],
                      ),
                    ),
                  )

                // --------------------------------------------------
                // Folder List
                // --------------------------------------------------

                else

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),

                    sliver: SliverList(
                      delegate:
                      SliverChildBuilderDelegate(
                            (context, index) {

                          final folderData =
                          Map<String, dynamic>.from(
                            folderList[index],
                          );

                          final String folderId =
                              folderData['Id']
                                  ?.toString() ??
                                  '';

                          final String folderTitle =
                              folderData['Title']
                                  ?.toString() ??
                                  'Untitled';

                          final cardCount =
                              cardsBox.values.where(
                                    (item) {
                                  final card =
                                  Map<String, dynamic>.from(
                                    item,
                                  );

                                  return card['FolderId']
                                      ?.toString() ==
                                      folderId;
                                },
                              ).length;

                          final delay =
                              400 + (index * 80);

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),

                            padding:
                            const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(16),

                              border: Border.all(
                                color:
                                Colors.grey.shade200,
                              ),
                            ),

                            child: Row(
                              children: [

                                // Folder icon
                                Container(
                                  padding:
                                  const EdgeInsets.all(
                                    10,
                                  ),

                                  decoration: BoxDecoration(
                                    color: primary
                                        .withOpacity(0.08),
                                    borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                                  ),

                                  child: Icon(
                                    Icons.folder_open_rounded,
                                    color: primary,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Folder information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      Text(
                                        folderTitle,

                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,

                                        style:
                                        const TextStyle(
                                          fontWeight:
                                          FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        '$cardCount ${cardCount == 1 ? 'card' : 'cards'}',

                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors
                                              .grey
                                              .shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons
                                      .chevron_right_rounded,
                                  size: 20,
                                  color:
                                  Colors.grey.shade400,
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(
                            delay: delay.ms,
                            duration: 400.ms,
                          )
                              .slideX(
                            begin: 0.06,
                            end: 0,
                            delay: delay.ms,
                            duration: 400.ms,
                            curve:
                            Curves.easeOutCubic,
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

  Widget _buildStatItem({
    required String label,
    required String value,
  }) {
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

          const SizedBox(height: 3),

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
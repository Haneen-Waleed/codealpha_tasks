import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/colors.dart';
import '../../../cubit/user_cubit.dart';
import '../../splash/screens/splash_screen.dart';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    final quizBox = Hive.box('QuizResults');

    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 3,
      ),
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: quizBox.listenable(),
          builder: (context, Box box, _) {
            final quizList = box.values.toList();

            int totalScore = 0;
            int totalQuestions = 0;

            for (var item in quizList) {
              final map = Map<String, dynamic>.from(item);
              final score = (map['score'] as num?)?.toInt() ?? 0;
              final questions = (map['totalQuestions'] as num?)?.toInt() ?? 0;

              totalScore += score;
              totalQuestions += questions;
            }

            // حساب متوسط الدرجات المئوي
            final double avgPercentage = totalQuestions > 0
                ? (totalScore / totalQuestions) * 100
                : 0.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // User Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primary.withOpacity(0.1),
                      child: Text(
                        userState.name.isNotEmpty
                            ? userState.name[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 450.ms)
                        .scale(
                      begin: const Offset(0.85, 0.85),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    ),

                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      userState.name.isEmpty ? 'Student' : userState.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 120.ms, duration: 400.ms)
                        .slideY(
                      begin: 0.15,
                      end: 0,
                      delay: 120.ms,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Keep your learning journey organized.',
                      style: TextStyle(
                        fontSize: 13,
                        color: grey,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 220.ms, duration: 400.ms),

                    const SizedBox(height: 28),

                    // ==========================================
                    // PERFORMANCE & BADGES (BASED ON AVERAGE %)
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: lightGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Level & Rank',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Avg: ${avgPercentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildBadgeItem(
                                icon: Icons.star_outline_rounded,
                                title: 'Beginner',
                                subtitle: '≤ 0%',
                                isUnlocked: avgPercentage <= 0,
                                color: const Color(0xFF6C757D), // Grey/Slate
                              ),
                              _buildBadgeItem(
                                icon: Icons.workspace_premium_rounded,
                                title: 'Bronze',
                                subtitle: '< 70%',
                                isUnlocked: avgPercentage > 0 && avgPercentage < 70,
                                color: const Color(0xFFCD7F32), // Bronze
                              ),
                              _buildBadgeItem(
                                icon: Icons.military_tech_rounded,
                                title: 'Silver',
                                subtitle: '< 90%',
                                isUnlocked: avgPercentage >= 70 && avgPercentage < 90,
                                color: const Color(0xFF4A6572), // Silver/Steel
                              ),
                              _buildBadgeItem(
                                icon: Icons.emoji_events_rounded,
                                title: 'Gold',
                                subtitle: '≥ 90%',
                                isUnlocked: avgPercentage >= 90,
                                color: const Color(0xFFFFB300), // Gold
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 250.ms, duration: 450.ms)
                        .slideY(
                      begin: 0.08,
                      end: 0,
                      delay: 250.ms,
                      duration: 450.ms,
                      curve: Curves.easeOut,
                    ),

                    const SizedBox(height: 20),

                    // Account Actions Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: lightGrey,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Account name
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 3,
                            ),
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: primary,
                                size: 20,
                              ),
                            ),
                            title: const Text(
                              'Account Name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              userState.name,
                              style: TextStyle(
                                color: grey,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: lightGrey,
                          ),

                          // Edit profile
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 3,
                            ),
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: primary,
                                size: 19,
                              ),
                            ),
                            title: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Update your name or password',
                              style: TextStyle(
                                color: grey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey.shade400,
                            ),
                            onTap: () {
                              editProfileDialog(context);
                            },
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 450.ms)
                        .slideY(
                      begin: 0.08,
                      end: 0,
                      delay: 300.ms,
                      duration: 450.ms,
                      curve: Curves.easeOut,
                    ),

                    const SizedBox(height: 32),

                    // Delete Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: red,
                          backgroundColor: red.withOpacity(0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          _logout(context);
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 19,
                        ),
                        label: const Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 380.ms, duration: 400.ms)
                        .slideY(
                      begin: 0.1,
                      end: 0,
                      delay: 380.ms,
                      duration: 400.ms,
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadgeItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isUnlocked,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? color.withOpacity(0.18) : Colors.grey.shade100,
            border: Border.all(
              color: isUnlocked ? color : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: isUnlocked ? color : Colors.grey.shade400,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.w600,
            color: isUnlocked ? textDark : textDark.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: isUnlocked ? color : grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: primary,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }

                if (!context.read<UserCubit>().checkPassword(value)) {
                  return 'Incorrect password';
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: primary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
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

    if (confirmed == true) {
      await context.read<UserCubit>().logout();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        ),
            (route) => false,
      );
    }

    passwordController.dispose();
  }
}
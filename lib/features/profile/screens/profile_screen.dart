import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/colors.dart';
import '../../../cubit/user_cubit.dart';
import '../../register/screens/register_screen.dart';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;

    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: const CustomBottomNavBar(
        selectedIndex: 3,
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            children: [

              const SizedBox(height: 20),

              // ─────────────────────────
              // Avatar
              // ─────────────────────────

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
                  .fadeIn(
                duration: 450.ms,
              )
                  .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),

              const SizedBox(height: 16),

              // ─────────────────────────
              // Name
              // ─────────────────────────

              Text(
                userState.name.isEmpty
                    ? 'Student'
                    : userState.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              )
                  .animate()
                  .fadeIn(
                delay: 120.ms,
                duration: 400.ms,
              )
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
                  color: Colors.grey.shade500,
                ),
              )
                  .animate()
                  .fadeIn(
                delay: 220.ms,
                duration: 400.ms,
              ),

              const SizedBox(height: 38),

              // ─────────────────────────
              // Profile Card
              // ─────────────────────────

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
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
                      title: Text(
                        'Account Name',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        userState.name,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.grey.shade200,
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
                          color: Colors.grey.shade500,
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
                  .fadeIn(
                delay: 280.ms,
                duration: 450.ms,
              )
                  .slideY(
                begin: 0.08,
                end: 0,
                delay: 280.ms,
                duration: 450.ms,
                curve: Curves.easeOut,
              ),

              const Spacer(),

              // ─────────────────────────
              // Logout
              // ─────────────────────────

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
                    'Log Out',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                delay: 400.ms,
                duration: 400.ms,
              )
                  .slideY(
                begin: 0.1,
                end: 0,
                delay: 400.ms,
                duration: 400.ms,
              ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // Logout confirmation
  // ─────────────────────────────────────

  Future<void> _logout(BuildContext context) async {
    final passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Text(
            'Confirm Logout',
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
                'Log Out',
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
          builder: (_) => const RegisterScreen(),
        ),
            (route) => false,
      );
    }

    passwordController.dispose();
  }
}
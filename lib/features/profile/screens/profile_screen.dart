import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/user_cubit.dart';
import '../../register/screens/register_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Minimalist Avatar
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
              ),

              const SizedBox(height: 16),

              Text(
                userState.name.isEmpty ? 'Student' : userState.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 40),

              // Profile Section Tile
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline_rounded, color: primary),
                      title: const Text('Account Name'),
                      trailing: Text(
                        userState.name,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _deleteAccount(context);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Your Profile'),
          content: const Text(
            'All folders and Cards will be permanently deleted.',
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
                'Log Out',
                style: TextStyle(color: red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context
          .read<UserCubit>().logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        ),
            (route) => false,
      );
    }
  }
}
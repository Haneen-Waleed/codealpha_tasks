import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/features/favourite/screens/favourite_screen.dart';
import 'package:random_quotes/features/home/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.lightBlue,
        color: AppColors.white,

        items: const [
          Icon(
            Icons.home_filled,
            size: 30,
            color: AppColors.text,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: AppColors.text,
          ),
        ],

        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
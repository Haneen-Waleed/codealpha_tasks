import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/features/cards/screens/card_screen.dart';
import 'package:flash_cards/features/quiz/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/profile_screen.dart';


class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
  }

  void navigateTo(int index) {
    if (index == currentIndex) return;

    setState(() {
      currentIndex = index;
    });

    Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const CardScreen();
        break;
      case 2:
        screen = const QuizScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
      default:
        screen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      height: 68.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildItem(Icons.home_rounded, Icons.home_outlined, 0, 'Home'),
          buildItem(Icons.sticky_note_2_sharp, Icons.sticky_note_2_outlined, 1, 'Cards'),
          buildItem(Icons.edit, Icons.edit_outlined, 2, 'Quiz'),
          buildItem(Icons.person_rounded, Icons.person_outline_rounded, 3, 'Profile'),
        ],
      ),
    );
  }

  Widget buildItem(IconData activeIcon, IconData inactiveIcon, int index, String text) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => navigateTo(index),
      borderRadius: BorderRadius.circular(20.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22.r,
              color: isSelected ? primary : grey,
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11.sp,
                color: isSelected ? primary : grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
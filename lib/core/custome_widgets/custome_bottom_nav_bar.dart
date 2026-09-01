import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/features/cards/screens/card_screen.dart';
import 'package:flash_cards/features/quiz/screens/quiz_screen.dart';
import 'package:flash_cards/features/quiz/screens/quiz_setup_screen.dart';
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

    late Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const CardScreen();
        break;
      case 2:
        screen = const QuizSetupScreen();
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
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 64.h,
        margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 12.h),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildItem(
              Icons.home_outlined,
              Icons.home_rounded,
              0,
              'Home',
            ),
            buildItem(
              Icons.style_outlined,
              Icons.style_rounded,
              1,
              'Cards',
            ),
            buildItem(
              Icons.quiz_outlined,
              Icons.quiz_rounded,
              2,
              'Quiz',
            ),
            buildItem(
              Icons.person_outline_rounded,
              Icons.person_rounded,
              3,
              'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      IconData inactiveIcon,
      IconData activeIcon,
      int index,
      String text,
      ) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => navigateTo(index),
        borderRadius: BorderRadius.circular(16.r),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  key: ValueKey(isSelected),
                  size: 22.r,
                  color: isSelected ? primary : grey,
                ),
              ),

              SizedBox(height: 4.h),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: isSelected ? primary : grey,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(text),
              ),

              SizedBox(height: 4.h),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 4.w : 0,
                height: 4.w,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flash_cards/core/colors.dart';
import 'package:flutter/material.dart';

import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2,),
      body: Center(child: Text('Quiz'),),
    );  }
}

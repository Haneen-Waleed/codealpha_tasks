import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0,),
      body: Center(child: Text('Home'),),

    );  }
}

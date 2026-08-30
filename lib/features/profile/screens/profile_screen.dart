import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../core/custome_widgets/custome_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 3,),
      body: Center(child: Text('Profile'),),

    );  }
}


import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final myBox = Hive.box('FlashCards');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
     body: Center(child: Text('Home'),),
    );
  }
}
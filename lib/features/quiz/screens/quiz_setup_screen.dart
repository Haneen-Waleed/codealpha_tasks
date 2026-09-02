import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/core/custome_widgets/custom_button.dart';
import 'package:flash_cards/core/custome_widgets/custome_bottom_nav_bar.dart';
import 'package:flash_cards/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../bloc/quiz_bloc.dart';
import '../../../bloc/quiz_event.dart';
import '../../../models/flash_card_model.dart';
import 'quiz_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int selectedMinutes = 5;
  String selectedSource = 'random';
  String? selectedFolderId;

  final List<int> durations = [1, 5, 10, 15, 30];

  List<Flashcard> get allCards {
    final box = Hive.box('FlashCards');
    return box.values.map((item) {
      final data = Map<String, dynamic>.from(item);
      return Flashcard(
        question: data['Question']?.toString() ?? '',
        answer: data['Answer']?.toString() ?? '',
        hint: data['Hint']?.toString() ?? '',
        folderId: data['FolderId']?.toString() ?? '',
      );
    }).toList();
  }

  List<Map<String, dynamic>> get folders {
    final box = Hive.box('Folders');
    return box.values.map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Quiz Setup',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header text
              const Text(
                'Configure Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Set your time limit and question pool to get started.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section: Duration
                    _buildLabel('DURATION'),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: selectedMinutes,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: _inputDecoration(
                        hint: 'Select duration',
                        icon: Icons.timer_outlined,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      items: durations.map((minutes) {
                        return DropdownMenuItem<int>(
                          value: minutes,
                          child: Text(
                            '$minutes Minutes',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedMinutes = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 28),

                    // Section: Source selection
                    _buildLabel('QUESTION SOURCE'),
                    const SizedBox(height: 10),

                    // Segmented Toggle Control
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSegmentTab(
                              title: 'All Cards',
                              value: 'random',
                              icon: Icons.shuffle_rounded,
                            ),
                          ),
                          Expanded(
                            child: _buildSegmentTab(
                              title: 'Specific Folder',
                              value: 'folder',
                              icon: Icons.folder_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (selectedSource == 'folder') ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedFolderId,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        decoration: _inputDecoration(
                          hint: 'Select Folder',
                          icon: Icons.folder_open_rounded,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        items: folders.map((folder) {
                          return DropdownMenuItem<String>(
                            value: folder['Id'].toString(),
                            child: Text(
                              folder['Title'].toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFolderId = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CustomButton(text: 'Start Quiz',onPressed: _startQuiz,)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _buildSegmentTab({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final bool isSelected = selectedSource == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSource = value;
          if (value == 'random') {
            selectedFolderId = null;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  void _startQuiz() {
    if (selectedSource == 'folder' && selectedFolderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text(
            'Please select a folder to continue',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    List<Flashcard> quizCards;
    String folderId;

    if (selectedSource == 'random') {
      quizCards = List<Flashcard>.from(allCards);
      folderId = 'random';
    } else {
      quizCards = allCards
          .where((card) => card.folderId == selectedFolderId)
          .toList();
      folderId = selectedFolderId!;
    }

    if (quizCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text(
            'No cards available for this selection',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => QuizBloc()
            ..add(
              StartQuizEvent(
                cards: quizCards,
                duration: Duration(minutes: selectedMinutes),
                folderId: folderId,
              ),
            ),
          child: const QuizScreen(),
        ),
      ),
    );
  }
}
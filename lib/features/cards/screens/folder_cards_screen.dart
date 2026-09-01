import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flash_cards/features/cards/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FolderCardsScreen extends StatefulWidget {
  final Folder folder;

  const FolderCardsScreen({
    super.key,
    required this.folder,
  });

  @override
  State<FolderCardsScreen> createState() => _FolderCardsScreenState();
}

class _FolderCardsScreenState extends State<FolderCardsScreen> {
  final flashCardsBox = Hive.box('FlashCards');

  late List<Flashcard> cards;

  late PageController pageController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    cards = flashCardsBox.values
        .map(
          (item) => Flashcard.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .where(
          (card) => card.folderId == widget.folder.id,
    )
        .toList();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.folder.name,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: cards.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.style_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "No Flashcards Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Add a flashcard to this folder",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          const SizedBox(height: 20),

          // Counter
          Text(
            "${currentIndex + 1} / ${cards.length}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: cards.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final card = cards[index];

                return CardWidget(
                  question: card.question,
                  answer: card.answer,
                );
              },
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed:
                  currentIndex > 0 ? previousCard : null,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  iconSize: 28,
                  color: primary,
                ),

                Text(
                  "Swipe or use arrows",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),

                IconButton(
                  onPressed: currentIndex < cards.length - 1
                      ? nextCard
                      : null,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  iconSize: 28,
                  color: primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
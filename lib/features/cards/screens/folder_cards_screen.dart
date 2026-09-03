import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_event.dart';
import 'package:flash_cards/bloc/flash_cards_state.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:flash_cards/models/flash_card_model.dart';
import 'package:flash_cards/features/cards/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/edit_flash_card_widget.dart';

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
    _loadCards();
  }

  void _loadCards() {
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

  int _getHiveIndex(Flashcard card) {
    final keys = flashCardsBox.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final map = Map<String, dynamic>.from(flashCardsBox.getAt(i));
      final current = Flashcard.fromMap(map);
      if (current.question == card.question &&
          current.answer == card.answer &&
          current.folderId == card.folderId) {
        return i;
      }
    }
    return -1;
  }

  Future<void> _deleteCard(BuildContext context) async {
    if (cards.isEmpty) return;

    final currentCard = cards[currentIndex];
    final hiveIndex = _getHiveIndex(currentCard);

    if (hiveIndex == -1) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete flashcard?'),
          content: const Text(
            'Are you sure you want to delete this flashcard?',
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
                'Delete',
                style: TextStyle(color: red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context.read<FlashCardsBloc>().add(
        DeleteFlashCardEvent(hiveIndex),
      );
    }
  }

  void _editCard(BuildContext context) {
    if (cards.isEmpty) return;

    final currentCard = cards[currentIndex];
    final hiveIndex = _getHiveIndex(currentCard);

    if (hiveIndex == -1) return;

    dialogBuilderEdit(context, hiveIndex, currentCard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlashCardsBloc, FlashCardsState>(
      listener: (context, state) {
        setState(() {
          _loadCards();
          if (currentIndex >= cards.length && currentIndex > 0) {
            currentIndex = cards.length - 1;
          }
        });
      },
      builder: (context, state) {
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
            actions: cards.isNotEmpty
                ? [
              IconButton(
                onPressed: () => _editCard(context),
                icon: const Icon(Icons.edit_outlined),
                color: primary,
                tooltip: 'Edit Card',
              ),
              IconButton(
                onPressed: () => _deleteCard(context),
                icon: const Icon(Icons.delete_outline),
                color: red,
                tooltip: 'Delete Card',
              ),
            ]
                : null,
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "${currentIndex + 1} / ${cards.length}",
                  key: ValueKey(currentIndex),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
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
                    )
                        .animate(
                      key: ValueKey(index),
                    )
                        .fadeIn(
                      duration: 300.ms,
                    )
                        .scale(
                      begin: const Offset(0.97, 0.97),
                      end: const Offset(1, 1),
                      duration: 300.ms,
                      curve: Curves.easeOut,
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
                      onPressed: currentIndex > 0 ? previousCard : null,
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 24,
                      color: primary,
                    )
                        .animate(
                      target: currentIndex > 0 ? 1 : 0,
                    )
                        .scale(
                      end: const Offset(1.05, 1.05),
                      duration: 200.ms,
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
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 24,
                      color: primary,
                    )
                        .animate(
                      target: currentIndex < cards.length - 1 ? 1 : 0,
                    )
                        .scale(
                      end: const Offset(1.05, 1.05),
                      duration: 200.ms,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flash_cards/core/custome_widgets/confirm_action_widget.dart';
import 'package:flash_cards/core/custome_widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flash_cards/core/colors.dart';
import 'package:flash_cards/models/quiz_result_model.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizBox = Hive.box('QuizResults');
    final foldersBox = Hive.box('Folders');

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Quiz History', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (quizBox.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep_rounded, color: red),
              onPressed: () => _confirmClearAll(context, quizBox),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: quizBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 70, color: lightGrey),
                  const SizedBox(height: 12),
                  Text('No Quizzes Taken Yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              // Hive items ordering reversed for latest first
              final realIndex = box.length - 1 - index;
              final rawData = Map<String, dynamic>.from(box.getAt(realIndex));
              final result = QuizResultModel.fromMap(rawData);

              // Get Folder Title
              String folderName = 'Shuffle';
              for (var f in foldersBox.values) {
                final map = Map<String, dynamic>.from(f);
                if (map['Id'].toString() == result.folderId) {
                  folderName = map['Title'].toString();
                  break;
                }
              }

              final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(result.date);

              return Dismissible(
                key: Key(realIndex.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => box.deleteAt(realIndex),
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: result.isPerfect ? accent : Colors.grey.shade200, width: result.isPerfect ? 1.5 : 1),
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: result.isPerfect ? secondary : primary.withOpacity(0.1),
                        child: Icon(
                          result.isPerfect ? Icons.emoji_events_rounded : Icons.quiz_rounded,
                          color: result.isPerfect ? primary : primary,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              folderName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (result.isPerfect)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(8)),
                              child: const Text('PERFECT!', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Score: ${result.score} / ${result.totalQuestions} (${result.percentage.toStringAsFixed(0)}%)'),
                          Text(formattedDate, style: TextStyle(fontSize: 11, color: grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context, Box box) {
    ConfirmActionWidget().confirmAction(context, action: (){box.clear();
    Navigator.pop(context);},
    title: 'Clear History?',
      subTitle: ' This will delete all quiz attempt records permanently.'
    );
  }
}
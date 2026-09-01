
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flash_cards_event.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'flash_cards_state.dart';
class FlashCardsBloc extends Bloc<FlashCardEvents, FlashCardsState> {
  FlashCardsBloc() : super(InitialFlashCard()) {
    final myBox = Hive.box('FlashCards');
    on<AddFlashCardEvent>((event, emit) {
    myBox.add({
    "Question": event.flashcard.question,
    "Answer": event.flashcard.answer,
    "Hint": event.flashcard.hint,
    "FolderId": event.flashcard.folderId,
    });
    emit(AddFlashCard());
    });
    on<DeleteFlashCardEvent>((event, emit) {
    myBox.deleteAt(event.index);
    emit(DeleteFlashCard());
    });
    on<DeleteAllFlashCardsEvent>((event, emit) {
    myBox.deleteAll(myBox.keys);
    emit(DeleteAllFlashCard());
    });

    on<EditFlashCardEvent>((event, emit) {
    var item = Map<String, dynamic>.from(myBox.getAt(event.index));
    item["Question"] = event.flashcard.question;
    item["Answer"] = event.flashcard.answer;
    item["Hint"] = event.flashcard.hint;
    item["FolderId"] = event.flashcard.folderId;

    myBox.putAt(event.index, item);
    emit(EditFlashCard());
    });
    }
  }


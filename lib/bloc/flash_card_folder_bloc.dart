import 'package:bloc/bloc.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:meta/meta.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'flash_card_folder_event.dart';
part 'flash_card_folder_state.dart';

class FlashCardFolderBloc extends Bloc<FlashCardFolderEvent, FlashCardFolderState> {
  FlashCardFolderBloc() : super(InitialFlashCardFolder()) {
    final myBox = Hive.box('Folders');
    final cardsBox = Hive.box('FlashCards');

    on<AddFlashCardFolderEvent>((event, emit) {
      myBox.add({
        "Title": event.folder.name,
        "Id": event.folder.id,
      });
      emit(AddFlashCardFolder());
    });

    on<DeleteFlashCardFolderEvent>((event, emit) {
      final folderData = Map<String, dynamic>.from(myBox.getAt(event.index));
      final String folderId = folderData["Id"]?.toString() ?? '';

      final keysToDelete = <dynamic>[];
      for (var key in cardsBox.keys) {
        final cardData = Map<String, dynamic>.from(cardsBox.get(key));
        if (cardData['FolderId']?.toString() == folderId) {
          keysToDelete.add(key);
        }
      }

      if (keysToDelete.isNotEmpty) {
        cardsBox.deleteAll(keysToDelete);
      }

      // 4. نمسح الفولدر نفسه
      myBox.deleteAt(event.index);

      emit(DeleteFlashCardFolder());
    });

    on<DeleteAllFlashCardFolderEvent>((event, emit) {
      // مسح كل الفولدرات وكل الكاردز
      cardsBox.deleteAll(cardsBox.keys);
      myBox.deleteAll(myBox.keys);

      emit(DeleteAllFlashCardFolder());
    });

    on<EditFlashCardFolderEvent>((event, emit) {
      var item = Map<String, dynamic>.from(myBox.getAt(event.index));
      item["Title"] = event.name;
      myBox.putAt(event.index, item);
      emit(EditFlashCardFolder());
    });
  }
}
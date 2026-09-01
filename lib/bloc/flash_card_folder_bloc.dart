import 'package:bloc/bloc.dart';
import 'package:flash_cards/models/folder_model.dart';
import 'package:meta/meta.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'flash_card_folder_event.dart';
part 'flash_card_folder_state.dart';

class FlashCardFolderBloc extends Bloc<FlashCardFolderEvent, FlashCardFolderState> {
  FlashCardFolderBloc() : super(InitialFlashCardFolder()) {
    final myBox = Hive.box('Folders');
    on<AddFlashCardFolderEvent>((event, emit) {
      myBox.add({
        "Title": event.folder.name,
        "Id": event.folder.id,
      });
      emit(AddFlashCardFolder());
    });
    on<DeleteFlashCardFolderEvent>((event, emit) {
      myBox.deleteAt(event.index);
      emit(DeleteFlashCardFolder());
    });
    on<DeleteAllFlashCardFolderEvent>((event, emit) {
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

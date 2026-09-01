part of 'flash_card_folder_bloc.dart';

@immutable
sealed class FlashCardFolderEvent {}
final class InitialFlashCardEvent extends FlashCardFolderEvent {}
final class AddFlashCardFolderEvent extends FlashCardFolderEvent {
  Folder folder;
  AddFlashCardFolderEvent(this.folder);
}
final class DeleteFlashCardFolderEvent extends FlashCardFolderEvent {
  int index;
  DeleteFlashCardFolderEvent(this.index);
}
final class DeleteAllFlashCardFolderEvent extends FlashCardFolderEvent {}
final class EditFlashCardFolderEvent extends FlashCardFolderEvent {
  int index;
  String name;
  EditFlashCardFolderEvent(this.index,this.name);
}
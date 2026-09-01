part of 'flash_card_folder_bloc.dart';

@immutable
sealed class FlashCardFolderState {}
final class InitialFlashCardFolder extends FlashCardFolderState {}
final class AddFlashCardFolder extends FlashCardFolderState {}
final class DeleteFlashCardFolder extends FlashCardFolderState {}
final class DeleteAllFlashCardFolder extends FlashCardFolderState {}
final class EditFlashCardFolder extends FlashCardFolderState {}

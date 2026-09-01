import 'package:flash_cards/models/flash_card_model.dart';

sealed class FlashCardEvents {}
final class InitialFlashCardEvent extends FlashCardEvents {}
final class AddFlashCardEvent extends FlashCardEvents {
  Flashcard flashcard;
  AddFlashCardEvent(this.flashcard);
}
final class DeleteFlashCardEvent extends FlashCardEvents {
  int index;
  DeleteFlashCardEvent(this.index);
}
final class DeleteAllFlashCardsEvent extends FlashCardEvents {}
final class EditFlashCardEvent extends FlashCardEvents {
  int index;
  Flashcard flashcard;
  EditFlashCardEvent(this.index,this.flashcard);

}
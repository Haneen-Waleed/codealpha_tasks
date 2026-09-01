
sealed class FlashCardsState {}

final class InitialFlashCard extends FlashCardsState {}
final class AddFlashCard extends FlashCardsState {}
final class DeleteFlashCard extends FlashCardsState {}
final class DeleteAllFlashCard extends FlashCardsState {}
final class EditFlashCard extends FlashCardsState {}

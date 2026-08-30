part of 'flash_cards_cubit.dart';

@immutable
sealed class FlashCardsState {}

final class FlashCardsInitial extends FlashCardsState {}
final class AddFlashCard extends FlashCardsCubit{}
final class EditFlashCard extends FlashCardsCubit{}
final class DeleteFlashCard extends FlashCardsCubit{}
final class AddFolder extends FlashCardsCubit{}
final class DeleteFolder extends FlashCardsCubit{}

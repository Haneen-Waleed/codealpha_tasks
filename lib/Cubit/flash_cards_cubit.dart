import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'flash_cards_state.dart';

class FlashCardsCubit extends Cubit<FlashCardsState> {
  FlashCardsCubit() : super(FlashCardsInitial());
}

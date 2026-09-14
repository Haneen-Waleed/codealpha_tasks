import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:random_quotes/models/quote_model.dart';
import 'package:random_quotes/repo/quote_repo.dart';

import '../core/helpers/helper.dart';

part 'random_quotes_state.dart';
class RandomQuotesCubit extends Cubit<RandomQuotesState> {
  QuoteRepo repo = QuoteRepo();
  RandomQuotesCubit() : super(InitialRandomQuotes());
  void gettingData() async {
    try {
      var response = await repo.getData();
      emit(
        SuccessRandomQuotes(
          response,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(FailedRandomQuotes(e.toString()));
    }
  }

  Future<void> refreshQuote() async {
    if (state is! SuccessRandomQuotes) return;

    final currentState = state as SuccessRandomQuotes;

    emit(
      SuccessRandomQuotes(
        currentState.model,
        isRefreshing: true,
      ),
    );

    try {
      final model = await repo.getData();

      emit(
        SuccessRandomQuotes(
          model,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(FailedRandomQuotes(e.toString()));
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:random_quotes/models/quote_model.dart';
import 'package:random_quotes/repo/quote_repo.dart';

part 'random_quotes_state.dart';

class RandomQuotesCubit extends Cubit<RandomQuotesState> {
  QuoteRepo repo=QuoteRepo();
  RandomQuotesCubit() : super(InitialRandomQuotes());
  void gettingData()async{
    try{
      var response = await repo.getData();
      emit(SuccessRandomQuotes(response));
    }catch(e){
      emit(FailedRandomQuotes(e.toString()));
    }
  }
}

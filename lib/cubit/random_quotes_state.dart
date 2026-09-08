part of 'random_quotes_cubit.dart';

@immutable
sealed class RandomQuotesState {}

final class InitialRandomQuotes extends RandomQuotesState {}
final class SuccessRandomQuotes extends RandomQuotesState
{
  QuotesModel model ;
  SuccessRandomQuotes(this.model);
}
final class FailedRandomQuotes extends RandomQuotesState
{
  String error;
  FailedRandomQuotes(this.error);
}

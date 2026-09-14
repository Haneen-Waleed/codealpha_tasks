part of 'random_quotes_cubit.dart';

@immutable
sealed class RandomQuotesState {}

final class InitialRandomQuotes extends RandomQuotesState {}
final class SuccessRandomQuotes extends RandomQuotesState {
  final QuotesModel model;
  final bool isRefreshing;

  SuccessRandomQuotes(
      this.model, {
        this.isRefreshing = false,
      });
}
final class FailedRandomQuotes extends RandomQuotesState
{
  String error;
  FailedRandomQuotes(this.error);
}

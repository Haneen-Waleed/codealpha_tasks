
import '../models/quote_model.dart';

sealed class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<QuotesModel> favorites;

  FavoriteSuccess(this.favorites);
}

class FavoriteError extends FavoriteState {
  final String error;

  FavoriteError(this.error);
}
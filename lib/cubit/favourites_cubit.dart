import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_quotes/core/helpers/helper.dart';
import 'package:random_quotes/features/favourite/repo/helpers.dart';
import 'package:random_quotes/models/quote_model.dart';

import 'favourites_state.dart';


class FavoriteCubit extends Cubit<FavoriteState> {
  final Helpers helpers = Helpers();

  FavoriteCubit() : super(FavoriteInitial());

  Future<void> getFavorites() async {
    emit(FavoriteLoading());

    try {
      final favorites = await helpers.getFavorites();

      emit(FavoriteSuccess(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> addFavorite(QuotesModel quote) async {
    try {
      final currentFavorites = await helpers.getFavorites();

      final exists = currentFavorites.any(
            (item) =>
        item.quote == quote.quote &&
            item.author == quote.author,
      );

      if (!exists) {
        currentFavorites.add(quote);

        await helpers.saveFavorites(currentFavorites);

        emit(FavoriteSuccess(currentFavorites));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> removeFavorite(QuotesModel quote) async {
    try {
      final currentFavorites = await helpers.getFavorites();

      currentFavorites.removeWhere(
            (item) =>
        item.quote == quote.quote &&
            item.author == quote.author,
      );

      await helpers.saveFavorites(currentFavorites);

      emit(FavoriteSuccess(currentFavorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
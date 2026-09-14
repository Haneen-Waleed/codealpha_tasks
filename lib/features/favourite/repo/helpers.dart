import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_quotes/models/quote_model.dart';

class Helpers {
  static const String onboardingKey = 'onboarding';
  static const String favoritesKey = 'favorites';

  Future<bool?> getOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey);
  }

  Future<void> saveFavorites(List<QuotesModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();

    final data = favorites
        .map((quote) => jsonEncode(quote.toJson()))
        .toList();

    await prefs.setStringList(favoritesKey, data);
  }

  Future<List<QuotesModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(favoritesKey) ?? [];

    return data.map((item) {
      return QuotesModel.fromJson(
        jsonDecode(item),
      );
    }).toList();
  }
}
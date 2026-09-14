import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:random_quotes/api_constants.dart';
import 'package:random_quotes/models/quote_model.dart';

class QuoteRepo {
  Future<QuotesModel> getData() async {
    final url = Uri.parse(randomQuotes);
    final response = await http.get(
      url,
      headers: apiKey
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);

      return QuotesModel.fromJson(data[0]);
    }
    throw Exception('Failed to load quote');
  }
}
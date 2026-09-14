import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:random_quotes/core/custom_widgets/quote_card_widget.dart';
import 'package:random_quotes/models/quote_model.dart'; // مسار الموديل الخاص بكِ
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomSearch extends SearchDelegate {
  final List<QuotesModel> quotesList;

  CustomSearch({required this.quotesList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear, color: AppColors.text),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
    );
  }

  List<QuotesModel> _getFilteredList() {
    return quotesList.where((item) {
      final quoteText = item.quote?.toLowerCase() ?? '';
      final authorText = item.author?.toLowerCase() ?? '';
      final searchText = query.toLowerCase().trim();

      return quoteText.contains(searchText) || authorText.contains(searchText);
    }).toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _getFilteredList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No quotes found!',
          style: AppTextStyles.quote(color: AppColors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(12.r),
      itemCount: results.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = results[index];
        return QuoteCardWidget(
          quote: item.quote ?? '',
          author: item.author ?? 'Unknown',
          fav: true,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _getFilteredList();

    if (query.isEmpty) {
      return Center(
        child: Text(
          'Type to search quotes or authors...',
          style: AppTextStyles.quote(color: AppColors.grey),
        ),
      );
    }

    if (suggestions.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: AppTextStyles.quote(color: AppColors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(
            item.quote ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(),
          ),
          subtitle: Text(
            item.author ?? 'Unknown',
            style: AppTextStyles.quote(color: AppColors.grey),
          ),
          leading: const Icon(Icons.format_quote, color: AppColors.text),
          onTap: () {
            query = item.quote ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}

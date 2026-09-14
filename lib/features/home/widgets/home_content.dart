import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_quotes/cubit/favourites_state.dart';
import 'package:random_quotes/models/quote_model.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/theme/colors.dart';
import '../../../core/custom_widgets/app_button.dart';
import '../../../core/custom_widgets/quote_card_widget.dart';
import '../../../core/custom_widgets/search_widget.dart';
import '../../../cubit/favourites_cubit.dart';
import '../../../cubit/random_quotes_cubit.dart';
import 'home_widget_helper.dart';

Widget homeContent({
  required String quote,
  required String author,
  required bool isRefreshing,
  required BuildContext context,
}) {
  return Column(
    children: [
      SizedBox(height: 10.h),

      SearchWidget(),

      SizedBox(height: 20.h),

      BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          bool isFav = false;

          if (state is FavoriteSuccess) {
            isFav = state.favorites.any(
              (item) => item.quote == quote && item.author == author,
            );
          }

          final currentQuoteModel = QuotesModel(quote: quote, author: author);

          return QuoteCardWidget(
            quote: quote,
            author: author,
            fav: isFav,
            onPressedFav: () {
              context.read<FavoriteCubit>().removeFavorite(currentQuoteModel);
            },
            onPressedNotFav: () {
              context.read<FavoriteCubit>().addFavorite(currentQuoteModel);
            },
          );
        },
      ),

      SizedBox(height: 20.h),

      AppButton(
        isLoading: isRefreshing,
        text: 'New Quote',
        color: AppColors.text,
        onTap: isRefreshing
            ? null
            : () {
                context.read<RandomQuotesCubit>().refreshQuote();
                HomeWidgetHelper.updateQuoteWidget(
                  quote: quote,
                  author: author,
                );
              },
      ),
    ],
  );
}

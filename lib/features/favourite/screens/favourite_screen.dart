import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/custom_widgets/quote_card_widget.dart';
import '../../../core/theme/fonts.dart';
import '../../../cubit/favourites_cubit.dart';
import '../../../cubit/favourites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColors = [
      AppColors.lightBlue,
      AppColors.lightGreen,
      AppColors.pink,
      AppColors.purple,

    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is FavoriteError) {
                return Center(
                  child: Text(state.error),
                );
              }

              if (state is FavoriteSuccess) {
                final favorites = state.favorites;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Favourites',
                          style: AppTextStyles.quote(),
                        ),

                        Text(
                          '${favorites.length} quotes',
                          style: AppTextStyles.normal(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50.h),

                    Expanded(
                      child: ListView.separated(
                        itemCount: favorites.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: 15.h),
                        itemBuilder: (context, index) {
                          final quote = favorites[index];

                          // Repeat the 4 colors
                          final cardColor =
                          cardColors[index % cardColors.length];

                          return QuoteCardWidget(
                            quote: quote.quote ?? '',
                            author: quote.author ?? 'Unknown',
                            fav: true,
                            color: cardColor,
                            onPressedFav: () {
                              context
                                  .read<FavoriteCubit>()
                                  .removeFavorite(quote);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

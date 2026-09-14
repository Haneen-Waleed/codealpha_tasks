import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_quotes/core/custom_widgets/search.dart';
import 'package:random_quotes/cubit/favourites_cubit.dart';
import 'package:random_quotes/cubit/favourites_state.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FavoriteError) {
          return Center(child: Text(state.error));
        }

        if (state is FavoriteSuccess) {
          final favorites = state.favorites;
          return GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: CustomSearch(quotesList: favorites),
              );
            },
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20.r),
              ),
              width: double.infinity,
              height: 44.h,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.text),
                     SizedBox(width: 5.w),
                    Text(
                      'Search in your favourite',
                      style: AppTextStyles.normal(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

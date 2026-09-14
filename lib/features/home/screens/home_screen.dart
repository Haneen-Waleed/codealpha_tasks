import 'package:flutter/material.dart';
import 'package:random_quotes/core/theme/colors.dart';
import 'package:random_quotes/core/theme/fonts.dart';
import 'package:random_quotes/cubit/random_quotes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/custom_widgets/app_button.dart';
import '../../../core/custom_widgets/search_widget.dart';
import '../widgets/home_content.dart';
import '../widgets/quote_card_skeleton.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 7.h),
          child: Text('Hello',style: AppTextStyles.title(),),
        ),

      ),
      backgroundColor: AppColors.white,

      body: BlocBuilder<RandomQuotesCubit, RandomQuotesState>(
        builder: (context, state) {
          switch (state) {
            case InitialRandomQuotes():
              return Column(
                children: [
                   SizedBox(height: 20.h),

                  SearchWidget(),

                   SizedBox(height: 20.h),

                  const QuoteCardSkeleton(),

                   SizedBox(height: 20.h),

                  AppButton(

                    text: 'new quote',
                    color: AppColors.text, isLoading: false,
                  ),
                ],
              );

            case FailedRandomQuotes():
              return Center(
                child: Text(state.error),
              );

            case SuccessRandomQuotes():
              return homeContent(
                quote: state.model.quote ?? '',
                author: state.model.author ?? 'Unknown',
                isRefreshing: state.isRefreshing,
                context: context,
              );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:random_quotes/core/colors.dart';
import 'package:random_quotes/core/fonts.dart';
import 'package:random_quotes/cubit/random_quotes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<RandomQuotesCubit, RandomQuotesState>(
        builder: (context, state) {
          switch (state) {
            case InitialRandomQuotes():
              return Center(child: CircularProgressIndicator());
            case FailedRandomQuotes():
              return Center(child: Text(state.error));
            case SuccessRandomQuotes():
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.model.quote ?? "",style: AppTextStyles.title,),
                  SizedBox(height: 10),
                  Text(state.model.author ?? ""),
                ],
              );
          }
        },
      ),
    );
  }
}

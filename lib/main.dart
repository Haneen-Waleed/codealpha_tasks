import 'package:flutter/material.dart';
import 'package:random_quotes/cubit/random_quotes_cubit.dart';
import 'package:random_quotes/features/home/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RandomQuotesCubit()..gettingData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff8CC0EB)),
        ),
        title: 'Random Quote',
        home: HomeScreen(),
      ),
    );
  }
}


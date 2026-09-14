import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:random_quotes/cubit/favourites_cubit.dart';
import 'package:random_quotes/cubit/random_quotes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_quotes/features/splash_screen/screens/splash_screen.dart';
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
        designSize: const Size(393, 830),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) =>
              RandomQuotesCubit()
                ..gettingData(),),
              BlocProvider(create: (context) =>
              FavoriteCubit()
                ..getFavorites(),)

            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff8CC0EB)),
              ),
              title: 'Random Quote',
              home: SplashScreen(),
            ),
          );
        }
    );
  }
}


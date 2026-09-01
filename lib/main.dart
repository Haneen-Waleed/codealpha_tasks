import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/quiz_bloc.dart';
import 'package:flash_cards/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await Hive.initFlutter();
  var boxFolders = await Hive.openBox('Folders');
  var boxCards = await Hive.openBox('FlashCards');
  var boxScores= await Hive.openBox('QuizResults');
  print(boxFolders.values);
  print(boxCards.values);
  print(boxScores.values);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FlashCardsBloc(),
        ),
        BlocProvider(
          create: (context) => FlashCardFolderBloc(),
        ),
        BlocProvider(create: (context) => QuizBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

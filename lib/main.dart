import 'package:flash_cards/bloc/flash_card_folder_bloc.dart';
import 'package:flash_cards/bloc/flash_cards_bloc.dart';
import 'package:flash_cards/bloc/quiz_bloc.dart';
import 'package:flash_cards/cubit/user_cubit.dart';
import 'package:flash_cards/features/home/screens/home_screen.dart';
import 'package:flash_cards/features/register/screens/register_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart'; // 1. أضيفي هذا الـ Import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  await Hive.initFlutter();
  var boxFolders = await Hive.openBox('Folders');
  var boxCards = await Hive.openBox('FlashCards');
  var boxScores = await Hive.openBox('QuizResults');

  print(boxFolders.values);
  print(boxCards.values);
  print(boxScores.values);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        BlocProvider(create: (context) => QuizBloc()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final isLoggedIn = context.select(
                  (UserCubit cubit) => cubit.state.isLoggedIn,
            );
            return isLoggedIn ? const HomeScreen() : const RegisterScreen();
          },
        ),
      ),
    );
  }
}
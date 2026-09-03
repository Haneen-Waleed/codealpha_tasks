import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserState {
  final String name;
  final String password;
  final bool isLoggedIn;

  UserState({
    this.name = '',
    this.password = '',
    this.isLoggedIn = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      isLoggedIn: map['isLoggedIn'] ?? false,
    );
  }
}

class UserCubit extends HydratedCubit<UserState> {
  UserCubit() : super(UserState());

  void registerUser(String name, String password) {
    emit(
      UserState(
        name: name,
        password: password,
        isLoggedIn: true,
      ),
    );
  }

  void updateProfile({
    required String name,
    required String password,
  }) {
    emit(
      UserState(
        name: name,
        password: password,
        isLoggedIn: true,
      ),
    );
  }

  bool checkPassword(String password) {
    return state.password == password;
  }

  Future<void> logout() async {
    final myBox1 = Hive.box('FlashCards');
    await myBox1.deleteAll(myBox1.keys);

    final myBox2 = Hive.box('Folders');
    await myBox2.deleteAll(myBox2.keys);

    final myBox3 = Hive.box('QuizResults');
    await myBox3.deleteAll(myBox3.keys);

    await clear();
    emit(UserState());
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    return state.toMap();
  }
}
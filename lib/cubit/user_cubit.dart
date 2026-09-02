import 'package:hydrated_bloc/hydrated_bloc.dart';

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
    emit(UserState(name: name, password: password, isLoggedIn: true));
  }

  void logout() {
    emit(UserState(name: '', password: '', isLoggedIn: false));
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) => UserState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(UserState state) => state.toMap();
}
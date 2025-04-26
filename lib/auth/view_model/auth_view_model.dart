import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';
import 'package:skill_swap/auth/data/reposatorys/auth_reposatory.dart';
import 'package:skill_swap/auth/view_model/auth_state.dart';
import 'package:skill_swap/shared/server_locator.dart';

class AuthViewModel extends Cubit<AuthState> {
  late final AuthReposatory authReposatory;
  AuthViewModel() : super(AuthInitial()) {
    authReposatory = AuthReposatory(
      authDataSource: ServerLocator.authDataSource,
    );
  }
  static UserModel? currentUser;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      currentUser = await authReposatory.login(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      currentUser = await authReposatory.register(
        name: name,
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(LogoutLoading());
    try {
      await authReposatory.signOut();
      currentUser = null;
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(LoginLoading());
    try {
      await authReposatory.resetPassword(email);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

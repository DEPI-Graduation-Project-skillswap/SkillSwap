import 'package:skill_swap/auth/data/data_source/auth_data_source.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';

class AuthReposatory {
  final AuthDataSource authDataSource;
  const AuthReposatory({required this.authDataSource});
  Future<UserModel> login({required String email, required String password}) {
    return authDataSource.login(email: email, password: password);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return authDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return authDataSource.signOut();
  }

  Future<void> resetPassword(String email) {
    return authDataSource.resetPassword(email);
  }
}

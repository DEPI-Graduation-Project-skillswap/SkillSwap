import 'package:skill_swap/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

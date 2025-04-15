import 'package:skill_swap/auth/data/data_source/auth_data_source.dart';
import 'package:skill_swap/auth/data/data_source/auth_firebase.dart';

class ServerLocator {
  static final AuthDataSource authDataSource = AuthFirebase();
}

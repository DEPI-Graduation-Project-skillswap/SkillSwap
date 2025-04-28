import 'package:skill_swap/auth/data/data_source/auth_data_source.dart';
import 'package:skill_swap/auth/data/data_source/auth_firebase.dart';
import 'package:skill_swap/home/data/data_source/home_data_source.dart';
import 'package:skill_swap/home/data/data_source/home_firebase_data_source.dart';
import 'package:skill_swap/settings/data/data_source/settings_data_source.dart';
import 'package:skill_swap/settings/data/data_source/settings_firebase_datasourc.dart';

class ServerLocator {
  static final AuthDataSource authDataSource = AuthFirebase();
  static final HomeDataSource homeDataSource = HomeFirebaseDataSource();
  static final SettingsDataSource settingsDataSource =
      SettingsFirebseDataSource();
}

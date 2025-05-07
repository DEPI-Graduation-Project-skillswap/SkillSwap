import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/settings/data/data_source/settings_data_source.dart';

class SettingsFirebaseDataSource extends SettingsDataSource {
  @override
  Future<void> signOut() => FirebaseAuth.instance.signOut();
}

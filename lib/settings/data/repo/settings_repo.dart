import 'package:skill_swap/settings/data/data_source/settings_data_source.dart';

class SettingsRepo {
  final SettingsDataSource dataSource;
  const SettingsRepo({required this.dataSource});
  Future<void> signOut() => dataSource.signOut();
}

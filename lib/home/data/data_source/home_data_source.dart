import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

abstract class HomeDataSource {
  Future<List<UserProfileModel>> getHomeUsers();
}

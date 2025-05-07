import 'package:skill_swap/home/data/data_source/home_data_source.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class HomeRepository {
  HomeRepository({required this.homeDataSource});
  HomeDataSource homeDataSource;
  Future<List<UserProfileModel>> getHomeUsers() async {
    return await homeDataSource.getHomeUsers();
  }
}

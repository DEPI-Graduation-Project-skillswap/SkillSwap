import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/home/data/reposatoris/home_reposatory.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/shared/server_locator.dart';
import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

class HomeViewModel extends Cubit<HomeState> {
  late final HomeReposatory reposatory;
  HomeViewModel() : super(HomeInitialState()) {
    reposatory = HomeReposatory(homeDataSource: ServerLocator.homeDataSource);
    getHomeUsers();
  }

  Future<void> getHomeUsers() async {
    emit(HomeLoadingState());
    try {
      List<UserProfileModel> users = await reposatory.getHomeUsers();
      emit(HomeSuccessState(users: users));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }
}

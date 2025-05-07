import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/home/data/reposatoris/home_reposatory.dart';
import 'package:skill_swap/home/view_model/home_state.dart';
import 'package:skill_swap/shared/server_locator.dart';

class HomeViewModel extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeViewModel()
    : repository = HomeRepository(homeDataSource: ServerLocator.homeDataSource),
      super(HomeInitialState());

  Future<void> getHomeUsers() async {
    emit(HomeLoadingState());
    try {
      final users = await repository.getHomeUsers();
      if (users.isEmpty) {
        emit(HomeEmptyState());
      } else {
        emit(HomeSuccessState(users: users));
      }
    } catch (e) {
      emit(HomeErrorState(message: 'Failed to load users.'));
    }
  }
}

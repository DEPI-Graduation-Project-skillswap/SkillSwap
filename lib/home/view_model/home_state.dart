import 'package:skill_swap/user_profile/data/models/user_profile_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  List<UserProfileModel> users = [];
  HomeSuccessState({required this.users});
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}

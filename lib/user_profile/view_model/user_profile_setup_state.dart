abstract class UserProfileSetupState {}

class UserProfileSetupViewModelInitial extends UserProfileSetupState {}

class SuccessUserProfileSetupState extends UserProfileSetupState {}

class LoadingUserProfileSetupState extends UserProfileSetupState {}

class ErrorUserProfileSetupState extends UserProfileSetupState {
  final String errorMessage;
  ErrorUserProfileSetupState(this.errorMessage);
}

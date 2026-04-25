part of 'profile_cubit.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserInfoModel? user;

  UserProfileLoaded({this.user});
}

class UserProfileError extends UserProfileState {
  final String failure;
  UserProfileError({required this.failure});
}

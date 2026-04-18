part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserInfoModel? profileUserModel;

  ProfileLoaded({this.profileUserModel});
}

class ProfileError extends ProfileState {
  final String failure;
  ProfileError({required this.failure});
}

part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoaded extends AuthState {
  final UserInfoModel user;
  AuthLoaded({required this.user});
}

final class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

final class AuthForgetPasswordLoading extends AuthState {}

final class AuthForgetPasswordLoaded extends AuthState {}

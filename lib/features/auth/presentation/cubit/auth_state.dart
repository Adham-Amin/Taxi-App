part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoaded extends AuthState {
  final UserInfoModel user;
  AuthLoaded({required this.user});
}

/// Emitted after a successful Google sign-in for a brand-new account that has
/// no Firestore profile/role yet. Carries the Google profile data so the
/// complete-profile screen can prefill name/email/photo.
final class AuthGoogleNeedsProfile extends AuthState {
  final UserInfoModel googleData;
  AuthGoogleNeedsProfile({required this.googleData});
}

final class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

final class AuthForgetPasswordLoading extends AuthState {}

final class AuthForgetPasswordLoaded extends AuthState {}

part of 'settings_cubit.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserInfoModel? driver;

  SettingsLoaded({this.driver});
}

class SettingsError extends SettingsState {
  final String failure;
  SettingsError({required this.failure});
}

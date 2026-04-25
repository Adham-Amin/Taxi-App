import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/driver/settings/domain/repositories/driver_profile_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.driverProfileRepo}) : super(SettingsInitial());

  final DriverProfileRepo driverProfileRepo;

  Future<void> getDriverProfile() async {
    emit(SettingsLoading());
    final result = await driverProfileRepo.getDriverProfile();
    result.fold(
      (l) => emit(SettingsError(failure: l.message)),
      (r) => emit(SettingsLoaded(driver: r)),
    );
  }

  Future<void> updateDriverProfile({required UserInfoModel driver}) async {
    emit(SettingsLoading());
    final result = await driverProfileRepo.updateDriverProfile(driver: driver);
    result.fold(
      (l) => emit(SettingsError(failure: l.message)),
      (r) => emit(SettingsLoaded(driver: driver)),
    );
  }

  Future<void> changePassword({
    required String password,
    required String newPassword,
  }) async {
    emit(SettingsLoading());
    final result = await driverProfileRepo.changePassword(
      password: password,
      newPassword: newPassword,
    );
    result.fold(
      (l) => emit(SettingsError(failure: l.message)),
      (r) => emit(SettingsLoaded(driver: null)),
    );
  }

  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    emit(SettingsLoading());
    final result = await driverProfileRepo.changeEmail(
      password: password,
      newEmail: newEmail,
    );
    result.fold(
      (l) => emit(SettingsError(failure: l.message)),
      (r) => emit(SettingsLoaded(driver: null)),
    );
  }
}

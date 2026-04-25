import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/driver/settings/data/datasources/driver_profile_data_source.dart';
import 'package:taxi_app/features/driver/settings/domain/repositories/driver_profile_repo.dart';

class DriverProfileRepoImpl extends DriverProfileRepo {
  final DriverProfileDataSource driverProfileDataSource;
  DriverProfileRepoImpl({required this.driverProfileDataSource});
  @override
  Future<Either<Failure, UserInfoModel>> getDriverProfile() async {
    try {
      var user = await driverProfileDataSource.getDriverProfile();
      return Right(user.toUserInfoModel());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDriverProfile({
    required UserInfoModel driver,
  }) async {
    try {
      await driverProfileDataSource.updateDriverProfile(driver: driver);
      var user = await driverProfileDataSource.getDriverProfile();
      Prefs.setUser(user.toUserInfoModel());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String newPassword,

    required String password,
  }) async {
    try {
      await driverProfileDataSource.changePassword(
        password: password,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    try {
      await driverProfileDataSource.changeEmail(
        password: password,
        newEmail: newEmail,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

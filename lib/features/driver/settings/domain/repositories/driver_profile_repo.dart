import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

abstract class DriverProfileRepo {
  Future<Either<Failure, UserInfoModel>> getDriverProfile();

  Future<Either<Failure, void>> updateDriverProfile({
    required UserInfoModel driver,
  });

  Future<Either<Failure, void>> changePassword({
    required String password,
    required String newPassword,
  });

  Future<Either<Failure, void>> changeEmail({
    required String password,
    required String newEmail,
  });
}

import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserInfoModel>> getUserProfile();

  Future<Either<Failure, void>> updateUserProfile({
    required UserInfoModel profileUserModel,
  });
}

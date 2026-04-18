import 'package:dartz/dartz.dart';
import 'package:taxi_app/core/errors/failure.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/features/profile/data/datasources/user_profile_data_source.dart';
import 'package:taxi_app/features/user/features/profile/domain/repositories/user_profile_repo.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  final UserProfileDataSource userProfileDataSource;
  UserProfileRepoImpl({required this.userProfileDataSource});
  @override
  Future<Either<Failure, UserInfoModel>> getUserProfile() async {
    try {
      var user = await userProfileDataSource.getUserProfile();
      return Right(user.toUserInfoModel());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required UserInfoModel profileUserModel,
  }) async {
    try {
      await userProfileDataSource.updateUserProfile(
        userModel: profileUserModel,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

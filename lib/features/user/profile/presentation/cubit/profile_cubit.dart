import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/profile/domain/repositories/user_profile_repo.dart';

part 'profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({required this.userProfileRepo})
    : super(UserProfileInitial());

  final UserProfileRepo userProfileRepo;

  Future<void> getUserProfile() async {
    emit(UserProfileLoading());
    final result = await userProfileRepo.getUserProfile();
    result.fold(
      (failure) => emit(UserProfileError(failure: failure.message)),
      (profileUserModel) => emit(UserProfileLoaded(user: profileUserModel)),
    );
  }

  Future<void> updateUserProfile({
    required UserInfoModel profileUserModel,
  }) async {
    emit(UserProfileLoading());
    var result = await userProfileRepo.updateUserProfile(
      profileUserModel: profileUserModel,
    );
    result.fold(
      (failure) => emit(UserProfileError(failure: failure.message)),
      (profileUserModel) => emit(UserProfileLoaded()),
    );
  }

  Future<void> changePassword({
    required String newPassword,
    required String password,
  }) async {
    emit(UserProfileLoading());
    var result = await userProfileRepo.changePassword(
      password: password,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(UserProfileError(failure: failure.message)),
      (profileUserModel) => emit(UserProfileLoaded()),
    );
  }

  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    emit(UserProfileLoading());
    var result = await userProfileRepo.changeEmail(
      password: password,
      newEmail: newEmail,
    );
    result.fold(
      (failure) => emit(UserProfileError(failure: failure.message)),
      (profileUserModel) => emit(UserProfileLoaded()),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/user/features/profile/domain/repositories/user_profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.userProfileRepo}) : super(ProfileInitial());

  final UserProfileRepo userProfileRepo;

  Future<void> getUserProfile() async {
    emit(ProfileLoading());
    final result = await userProfileRepo.getUserProfile();
    result.fold(
      (failure) => emit(ProfileError(failure: failure.message)),
      (profileUserModel) =>
          emit(ProfileLoaded(profileUserModel: profileUserModel)),
    );
  }

  Future<void> updateUserProfile({
    required UserInfoModel profileUserModel,
  }) async {
    var result = await userProfileRepo.updateUserProfile(
      profileUserModel: profileUserModel,
    );
    result.fold(
      (failure) => emit(ProfileError(failure: failure.message)),
      (profileUserModel) => emit(ProfileLoaded()),
    );
  }
}

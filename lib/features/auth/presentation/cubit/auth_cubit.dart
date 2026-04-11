import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/repositories/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> userRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.userRegister(
      image: image,
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
    result.fold(
      (l) => emit(AuthError(message: l)),
      (r) => emit(AuthLoaded(user: r)),
    );
  }

  Future<void> driverRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String carModel,
    required String carColor,
    required String carPlateNumber,
    required double lat,
    required double lng,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.driverRegister(
      image: image,
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      carModel: carModel,
      carColor: carColor,
      carPlateNumber: carPlateNumber,
      lat: lat,
      lng: lng,
    );
    result.fold(
      (l) => emit(AuthError(message: l)),
      (r) => emit(AuthLoaded(user: r)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    var result = await authRepo.login(email: email, password: password);
    result.fold(
      (l) => emit(AuthError(message: l)),
      (r) => emit(AuthLoaded(user: r)),
    );
  }

  Future<void> forgetPassword({required String email}) async {
    emit(AuthForgetPasswordLoading());
    var result = await authRepo.forgetPassword(email: email);
    result.fold(
      (l) => emit(AuthError(message: l)),
      (r) => emit(AuthForgetPasswordLoaded()),
    );
  }
}

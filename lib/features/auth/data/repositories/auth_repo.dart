import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

abstract class AuthRepo {
  Future<Either<String, UserInfoModel>> userRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<Either<String, UserInfoModel>> driverRegister({
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
  });

  Future<Either<String, void>> forgetPassword({required String email});

  Future<Either<String, UserInfoModel>> login({
    required String email,
    required String password,
  });
}

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource;

  AuthRepoImpl({required this.authDataSource});
  @override
  Future<Either<String, UserInfoModel>> driverRegister({
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
    try {
      var user = await authDataSource.driverRegister(
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

      await Prefs.setUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left('Password should be at least 6 characters');
      } else if (e.code == 'email-already-in-use') {
        return left('Email already in use');
      } else {
        return left(e.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> forgetPassword({required String email}) async {
    try {
      await authDataSource.forgetPassword(email: email);
      return right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left('User not found');
      }
      return left(e.message ?? e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, UserInfoModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      var user = await authDataSource.login(email: email, password: password);
      await Prefs.setUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left('User not found');
      } else if (e.code == 'wrong-password') {
        return left('Wrong password');
      } else {
        return left(e.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, UserInfoModel>> userRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      var user = await authDataSource.userRegister(
        image: image,
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      await Prefs.setUser(user);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left('Password should be at least 6 characters');
      } else if (e.code == 'email-already-in-use') {
        return left('Email already in use');
      } else {
        return left(e.toString());
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}

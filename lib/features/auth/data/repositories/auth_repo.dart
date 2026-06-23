import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxi_app/core/services/notification_service.dart';
import 'package:taxi_app/core/services/shared_preferences_service.dart';
import 'package:taxi_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';

const String kGoogleSignInCancelled = '__google_cancelled__';

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

  /// Signs in with Google. On success returns the resolved user (with a role)
  /// for an existing account, or a [UserInfoModel] with an empty `role` carrying
  /// the Google profile data when the account is brand new (needs profile).
  Future<Either<String, UserInfoModel>> loginWithGoogle();

  Future<Either<String, UserInfoModel>> completeGoogleUserProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
  });

  Future<Either<String, UserInfoModel>> completeGoogleDriverProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
    required String carModel,
    required String carColor,
    required String carPlateNumber,
    required double lat,
    required double lng,
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
      await NotificationService.saveTokenForUser(
        user.id ?? '',
        user.role ?? '',
      );
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
      await NotificationService.saveTokenForUser(
        user.id ?? '',
        user.role ?? '',
      );
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
      await NotificationService.saveTokenForUser(
        user.id ?? '',
        user.role ?? '',
      );
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
  Future<Either<String, UserInfoModel>> loginWithGoogle() async {
    try {
      final user = await authDataSource.signInWithGoogle();
      final existing = await authDataSource.resolveExistingUser(user.uid);
      if (existing != null) {
        await Prefs.setUser(existing);
        await NotificationService.saveTokenForUser(
          existing.id ?? '',
          existing.role ?? '',
        );
        return Right(existing);
      }
      return Right(
        UserInfoModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          image: user.photoURL ?? '',
          phone: '',
          role: '',
        ),
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return left(kGoogleSignInCancelled);
      }
      return left(e.description ?? e.toString());
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, UserInfoModel>> completeGoogleUserProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
  }) async {
    try {
      final user = await authDataSource.completeGoogleUserProfile(
        name: name,
        phone: phone,
        googlePhotoUrl: googlePhotoUrl,
        image: image,
      );
      await Prefs.setUser(user);
      await NotificationService.saveTokenForUser(
        user.id ?? '',
        user.role ?? '',
      );
      return Right(user);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, UserInfoModel>> completeGoogleDriverProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
    required String carModel,
    required String carColor,
    required String carPlateNumber,
    required double lat,
    required double lng,
  }) async {
    try {
      final user = await authDataSource.completeGoogleDriverProfile(
        name: name,
        phone: phone,
        googlePhotoUrl: googlePhotoUrl,
        image: image,
        carModel: carModel,
        carColor: carColor,
        carPlateNumber: carPlateNumber,
        lat: lat,
        lng: lng,
      );
      await Prefs.setUser(user);
      await NotificationService.saveTokenForUser(
        user.id ?? '',
        user.role ?? '',
      );
      return Right(user);
    } catch (e) {
      return left(e.toString());
    }
  }
}

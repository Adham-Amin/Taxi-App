import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/core/functions/image_uploader.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserInfoModel> login({
    required String email,
    required String password,
  });

  Future<UserInfoModel> userRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<UserInfoModel> driverRegister({
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

  Future<void> forgetPassword({required String email});
}

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<void> forgetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserInfoModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserInfoModel(
      id: credential.user?.uid ?? '',
      name: credential.user?.displayName ?? '',
      email: credential.user?.email ?? '',
      role: credential.user?.photoURL ?? '',
    );
  }

  @override
  Future<UserInfoModel> userRegister({
    required File image,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user!.updateDisplayName(fullName);
    await credential.user!.updatePhotoURL("user");
    await credential.user!.reload();
    final updatedUser = FirebaseAuth.instance.currentUser!;

    await saveUserData(updatedUser, image, phone);

    return UserInfoModel(
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      role: updatedUser.photoURL ?? '',
    );
  }

  Future<void> saveUserData(User user, File image, String phone) async {
    await user.updatePhotoURL("user");
    var imageUrl = await uploadImageToCloudinary(image);
    var userData = UserModel(
      id: user.uid,
      image: imageUrl ?? '',
      name: user.displayName ?? '',
      phone: phone,
      email: user.email ?? '',
      role: user.photoURL ?? '',
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(userData.toMap());
  }

  @override
  Future<UserInfoModel> driverRegister({
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
    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(fullName);
    await credential.user!.updatePhotoURL("driver");
    await credential.user!.reload();
    final updatedUser = FirebaseAuth.instance.currentUser!;
    await saveDriverData(
      image,
      updatedUser,
      carModel,
      carColor,
      carPlateNumber,
      lat,
      lng,
      phone,
    );
    return UserInfoModel(
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      role: updatedUser.photoURL ?? '',
    );
  }

  Future<void> saveDriverData(
    File image,
    User updatedUser,
    String carModel,
    String carColor,
    String carPlateNumber,
    double lat,
    double lng,
    String phone,
  ) async {
    var imageUrl = await uploadImageToCloudinary(image);
    var driverData = DriverModel(
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      phone: phone,
      carModel: carModel,
      carColor: carColor,
      carPlateNumber: carPlateNumber,
      image: imageUrl ?? '',
      lat: lat,
      lng: lng,
      role: updatedUser.photoURL ?? '',
      isAvailable: true,
      rating: 0,
    );
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(updatedUser.uid)
        .set(driverData.toMap());
  }
}

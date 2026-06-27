import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/core/functions/image_uploader.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/models/user_model.dart';

abstract class UserProfileDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile({
    required UserInfoModel userModel,
    required File? file,
  });
  Future<void> changePassword({
    required String password,
    required String newPassword,
  });
  Future<void> changeEmail({
    required String password,
    required String newEmail,
  });
}

class UserProfileDataSourceImpl implements UserProfileDataSource {
  @override
  Future<UserModel> getUserProfile() async {
    var userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return UserModel.fromJson(userInfo.data()!);
  }

  @override
  Future<void> updateUserProfile({
    required UserInfoModel userModel,
    required File? file,
  }) async {
    if (file != null) {
      var imageUrl = await uploadImageToCloudinary(file);
      userModel.image = imageUrl ?? '';
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userModel.toUpdateData());
  }

  @override
  Future<void> changePassword({
    required String password,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }

  @override
  Future<void> changeEmail({
    required String password,
    required String newEmail,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    await user.verifyBeforeUpdateEmail(newEmail);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': newEmail});
  }
}

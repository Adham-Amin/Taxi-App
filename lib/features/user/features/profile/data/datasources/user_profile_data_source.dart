import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/models/user_model.dart';

abstract class UserProfileDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile({required UserInfoModel userModel});
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
  Future<void> updateUserProfile({required UserInfoModel userModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userModel.toUpdateData());
  }
}

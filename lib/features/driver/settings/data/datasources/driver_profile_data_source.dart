import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/models/user_model.dart';

abstract class DriverProfileDataSource {
  Future<UserModel> getDriverProfile();
  Future<void> updateDriverProfile({required UserInfoModel driver});
  Future<void> changePassword({
    required String password,
    required String newPassword,
  });
  Future<void> changeEmail({
    required String password,
    required String newEmail,
  });
}

class DriverProfileDataSourceImpl implements DriverProfileDataSource {
  @override
  Future<UserModel> getDriverProfile() async {
    var userInfo = await FirebaseFirestore.instance
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return UserModel.fromJson(userInfo.data()!);
  }

  @override
  Future<void> updateDriverProfile({required UserInfoModel driver}) async {
    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(driver.toUpdateData());
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
        .collection('drivers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': newEmail});
  }
}

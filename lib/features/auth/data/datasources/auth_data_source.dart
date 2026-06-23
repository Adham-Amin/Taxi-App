import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxi_app/core/functions/image_uploader.dart';
import 'package:taxi_app/features/auth/data/models/driver_model.dart';
import 'package:taxi_app/features/auth/data/models/user_info_model.dart';
import 'package:taxi_app/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserInfoModel> login({
    required String email,
    required String password,
  });

  /// Runs the native Google sign-in flow and authenticates with Firebase.
  /// Returns the signed-in [User]. Throws [GoogleSignInException] on cancel.
  Future<User> signInWithGoogle();

  /// Resolves an already-registered account by uid, detecting the role from
  /// whichever Firestore collection the uid lives in. Returns null if neither
  /// `drivers/{uid}` nor `users/{uid}` exists (i.e. a brand-new Google user).
  Future<UserInfoModel?> resolveExistingUser(String uid);

  Future<UserInfoModel> completeGoogleUserProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
  });

  Future<UserInfoModel> completeGoogleDriverProfile({
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
  // google_sign_in v7 requires initialize() to run once before authenticate().
  static bool _googleInitialized = false;

  @override
  Future<void> forgetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserInfoModel> login({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await resolveExistingUser(uid);
    if (user == null) {
      throw Exception("Data not found");
    }
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    if (!_googleInitialized) {
      await GoogleSignIn.instance.initialize();
      _googleInitialized = true;
    }
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user!;
  }

  @override
  Future<UserInfoModel?> resolveExistingUser(String uid) async {
    final driverDoc = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(uid)
        .get();
    if (driverDoc.exists) {
      return _mapDriver(DriverModel.fromMap(driverDoc.data()!));
    }

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
    if (userDoc.exists) {
      return _mapUser(UserModel.fromJson(userDoc.data()!));
    }

    return null;
  }

  UserInfoModel _mapDriver(DriverModel data) => UserInfoModel(
    lat: data.lat,
    lng: data.lng,
    carColor: data.carColor,
    carModel: data.carModel,
    carPlateNumber: data.carPlateNumber,
    name: data.name,
    email: data.email,
    role: "driver",
    id: data.id ?? '',
    image: data.image,
    phone: data.phone,
  );

  UserInfoModel _mapUser(UserModel data) => UserInfoModel(
    name: data.name,
    email: data.email,
    role: "user",
    id: data.id,
    image: data.image,
    phone: data.phone,
  );

  @override
  Future<UserInfoModel> completeGoogleUserProfile({
    required String name,
    required String phone,
    String? googlePhotoUrl,
    File? image,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(name);
    // Role marker kept in photoURL for parity with the email/password flow.
    await user.updatePhotoURL("user");
    await user.reload();
    final updatedUser = FirebaseAuth.instance.currentUser!;

    final imageUrl = await _resolveImageUrl(image, googlePhotoUrl);
    await saveUserData(updatedUser, imageUrl, phone);

    return UserInfoModel(
      image: imageUrl,
      phone: phone,
      id: updatedUser.uid,
      name: name,
      email: updatedUser.email ?? '',
      role: "user",
    );
  }

  @override
  Future<UserInfoModel> completeGoogleDriverProfile({
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
    final user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(name);
    await user.updatePhotoURL("driver");
    await user.reload();
    final updatedUser = FirebaseAuth.instance.currentUser!;

    final imageUrl = await _resolveImageUrl(image, googlePhotoUrl);
    await saveDriverData(
      imageUrl,
      updatedUser,
      carModel,
      carColor,
      carPlateNumber,
      lat,
      lng,
      phone,
    );

    return UserInfoModel(
      lat: lat,
      lng: lng,
      carColor: carColor,
      carModel: carModel,
      carPlateNumber: carPlateNumber,
      image: imageUrl,
      phone: phone,
      id: updatedUser.uid,
      name: name,
      email: updatedUser.email ?? '',
      role: "driver",
    );
  }

  /// Uploads a picked [image] to Cloudinary; otherwise falls back to the
  /// Google account photo url (or empty string).
  Future<String> _resolveImageUrl(File? image, String? googlePhotoUrl) async {
    if (image != null) {
      final uploaded = await uploadImageToCloudinary(image);
      if (uploaded != null) return uploaded;
    }
    return googlePhotoUrl ?? '';
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

    var imageUrl = await uploadImageToCloudinary(image);
    await saveUserData(updatedUser, imageUrl ?? '', phone);

    return UserInfoModel(
      image: imageUrl ?? '',
      phone: phone,
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      role: updatedUser.photoURL ?? '',
    );
  }

  Future<void> saveUserData(User user, String image, String phone) async {
    var userData = UserModel(
      id: user.uid,
      image: image,
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
    var imageUrl = await uploadImageToCloudinary(image);
    await saveDriverData(
      imageUrl ?? '',
      updatedUser,
      carModel,
      carColor,
      carPlateNumber,
      lat,
      lng,
      phone,
    );
    return UserInfoModel(
      lat: lat,
      lng: lng,
      carColor: carColor,
      carModel: carModel,
      carPlateNumber: carPlateNumber,
      image: imageUrl ?? '',
      phone: phone,
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      role: updatedUser.photoURL ?? '',
    );
  }

  Future<void> saveDriverData(
    String image,
    User updatedUser,
    String carModel,
    String carColor,
    String carPlateNumber,
    double lat,
    double lng,
    String phone,
  ) async {
    var driverData = DriverModel(
      id: updatedUser.uid,
      name: updatedUser.displayName ?? '',
      email: updatedUser.email ?? '',
      phone: phone,
      carModel: carModel,
      carColor: carColor,
      carPlateNumber: carPlateNumber,
      image: image,
      lat: lat,
      lng: lng,
      role: updatedUser.photoURL ?? '',
    );
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(updatedUser.uid)
        .set(driverData.toMap());
  }
}

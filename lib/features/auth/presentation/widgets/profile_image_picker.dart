import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_app/core/utils/app_assets.dart';
import 'package:taxi_app/core/utils/app_colors.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? file;
  final Function(File?) onPick;

  const ProfileImagePicker({
    super.key,
    required this.file,
    required this.onPick,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      onPick(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _pick(context),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: file != null
                  ? FileImage(file!)
                  : AssetImage(AppAssets.imagesPlacehorderPhoto),
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.lightGreen,
              child: Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

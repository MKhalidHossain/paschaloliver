import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/user_profile_interface.dart';

class UserProfileController extends GetxController {
  UserProfileController({required this.service});

  final UserProfileInterface service;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final nameLen = 0.obs;
  final avatarPath = "".obs;
  final imageUrl = "".obs;
  final displayName = "".obs;
  final userId = "".obs;

  final isLoading = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;
  final isEditing = false.obs;
  final error = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameCtrl.addListener(() {
      nameLen.value = nameCtrl.text.length;
      displayName.value = nameCtrl.text.trim();
    });
    fetchMe();
  }

  Future<void> fetchMe() async {
    try {
      isLoading.value = true;
      error.value = '';
      final me = await service.getMe();
      nameCtrl.text = me.name;
      emailCtrl.text = me.email;
      phoneCtrl.text = me.phone;
      imageUrl.value = me.image;
      displayName.value = me.name;
      userId.value = me.id;
      nameLen.value = nameCtrl.text.length;
      isEditing.value = false;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> save() async {
    try {
      isSaving.value = true;
      error.value = '';
      if (userId.value.isEmpty) {
        throw Exception("User id missing");
      }
      final updated = await service.updateMe(
        id: userId.value,
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      );
      imageUrl.value = updated.image;
      displayName.value = updated.name;
      isEditing.value = false;
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  void startEditing() {
    isEditing.value = true;
  }

  Future<void> deactivate() async {
    try {
      isDeleting.value = true;
      error.value = '';
      await service.deactivate();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (x == null) return;
      avatarPath.value = x.path;
    } catch (e) {
      Get.snackbar("Camera", "Camera error: $e");
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (x == null) return;
      avatarPath.value = x.path;
    } catch (e) {
      Get.snackbar("Photos", "Gallery error: $e");
    }
  }

  void openPhotoSheet() {
    Get.bottomSheet(
      _PhotoPickerSheet(
        onCamera: () async {
          Get.back();
          await pickFromCamera();
        },
        onGallery: () async {
          Get.back();
          await pickFromGallery();
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
    );
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}

class _PhotoPickerSheet extends StatelessWidget {
  const _PhotoPickerSheet({required this.onCamera, required this.onGallery});

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 12, 18, 12 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SheetItem(
                      icon: Icons.photo_camera_outlined,
                      label: "Camera",
                      onTap: onCamera,
                    ),
                    _SheetItem(
                      icon: Icons.photo_outlined,
                      label: "Photos",
                      onTap: onGallery,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  const _SheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF111111)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// ------------------------------------------------------------
/// Personal Details (UI SAME) + ✅ Working Camera/Gallery
/// - Tap camera button -> bottom sheet (Camera / Photos)
/// - Pick image -> shows in avatar (local preview)
/// ------------------------------------------------------------

class PersonalDetailsController extends GetxController {
  final nameCtrl = TextEditingController(text: "Paschaloliver");
  final emailCtrl = TextEditingController(text: "Paschaloliver@example.com");
  final phoneCtrl = TextEditingController();

  final nameLen = 0.obs;

  // ✅ selected avatar image path
  final avatarPath = "".obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameLen.value = nameCtrl.text.length;
    nameCtrl.addListener(() => nameLen.value = nameCtrl.text.length);
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
      Get.snackbar(
        "Camera",
        "Camera error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar(
        "Photos",
        "Gallery error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
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

class PerDetailsScreen extends StatelessWidget {
  const PerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PersonalDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          children: [
            _TopBar(
              title: "Personal Details",
              onBack: () => Get.back(),
              onEdit: () {
                Get.snackbar(
                  "Edit",
                  "Edit profile",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            const SizedBox(height: 22),

            // Avatar + camera button (UI SAME, only logic changed)
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE9E9E9),
                    ),
                    child: ClipOval(
                      child: Obx(() {
                        final path = c.avatarPath.value;

                        // ✅ show picked image if exists, otherwise show network fallback
                        if (path.isNotEmpty && File(path).existsSync()) {
                          return Image.file(File(path), fit: BoxFit.cover);
                        }

                        return Image.network(
                          "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=300&q=60",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF777777),
                          ),
                        );
                      }),
                    ),
                  ),

                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: InkWell(
                      onTap: c.openPhotoSheet, // ✅ working
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _C.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Name with counter (0/50)
 Obx(() {
  return _Field(
    controller: c.nameCtrl,
    hint: "Name",
    maxLength: 50,
    suffixText: "${c.nameLen.value}/50",
    keyboardType: TextInputType.name,
  );
}),

            const SizedBox(height: 12),

            _Field(
              controller: c.emailCtrl,
              hint: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            _Field(
              controller: c.phoneCtrl,
              hint: "Phone",
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 18),

            // Save button
            SizedBox(
              height: 46,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.snackbar(
                    "Saved",
                    "Personal details updated",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Center(
              child: InkWell(
                onTap: () {
                  Get.dialog(
                    _DeleteConfirmDialog(
                      onConfirm: () {
                        Get.back();
                        Get.snackbar(
                          "Account",
                          "Delete requested",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                child: Text(
                  "Delete account permanently",
                  textAlign: TextAlign.center, // Figma: center
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: _C.green, // Primary color
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationThickness: 1, // optional: keeps underline clean
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Photo Picker Bottom Sheet (functional only) ----------------
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
            Icon(icon, size: 28, color: _C.text),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _C.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- UI WIDGETS ----------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack, this.onEdit});
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700, // Bold
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),
          const Spacer(),
          if (onEdit != null)
            InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: _C.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.suffixText, // we will show it bottom-right (0/50)
    this.maxLength,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final String? suffixText;
  final int? maxLength;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final hasCounter = suffixText != null;

    return Container(
      height: hasCounter ? 56 : 52, // ✅ name field a bit taller (has counter)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF2F2F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // subtle shadow like screenshot
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLength: maxLength,
            keyboardType: keyboardType,
            style: GoogleFonts.urbanist(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.1,
              color: const Color(0xFF111111),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.urbanist(
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
                height: 1.1,
                color: const Color(0xFF9A9A9A),
              ),
              border: InputBorder.none,
              counterText: "", // ✅ hide default counter
              contentPadding: EdgeInsets.fromLTRB(
                14,
                16,
                14,
                hasCounter ? 26 : 16, // ✅ reserve space for bottom counter
              ),
            ),
          ),

          // ✅ Bottom-right counter inside the field (0/50)
          if (hasCounter)
            Positioned(
              right: 14,
              bottom: 8,
              child: Text(
                suffixText!,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  color: const Color(0xFF727272),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_forever_rounded, size: 34, color: _C.green),
            const SizedBox(height: 10),
            const Text(
              "Delete account?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _C.text,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _C.hint,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.text,
                      side: const BorderSide(color: _C.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _C {
  static const green = Color(0xFF27AE60);
  static const text = Color(0xFF111111);
  static const hint = Color(0xFF9A9A9A);
  static const line = Color(0xFFEDEDED);
}

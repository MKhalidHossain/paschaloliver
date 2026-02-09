import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/assets.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/profile/controller/user_profile_controller.dart';
import 'package:paschaloliver/feature/profile/services/user_profile_interface.dart';
import 'package:paschaloliver/feature/profile/services/user_profile_interface_impl.dart';

class PerDetailsScreen extends StatelessWidget {
  const PerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(ApiClient(ApiEndpoints.baseUrl), permanent: true);
    }
    if (!Get.isRegistered<UserProfileInterface>()) {
      Get.put<UserProfileInterface>(
        UserProfileInterfaceImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    if (!Get.isRegistered<UserProfileController>()) {
      Get.put<UserProfileController>(
        UserProfileController(service: Get.find<UserProfileInterface>()),
      );
    }
    final c = Get.find<UserProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            children: [
            _TopBar(
              title: "Personal Details",
              onBack: () => Get.back(),
              onEdit: () => c.startEditing(),
            ),
              const SizedBox(height: 22),

              // Avatar + camera button
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
                          final imageUrl = c.imageUrl.value;

                          if (path.isNotEmpty && File(path).existsSync()) {
                            return Image.file(File(path), fit: BoxFit.cover);
                          }

                          if (imageUrl.isNotEmpty) {
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Images.userPlaceholder,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return Image.asset(
                            Images.userPlaceholder,
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
                        onTap: c.openPhotoSheet,
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

              Obx(() {
                return _Field(
                  controller: c.nameCtrl,
                  hint: "Name",
                  maxLength: 50,
                  suffixText: "${c.nameLen.value}/50",
                  keyboardType: TextInputType.name,
                  enabled: c.isEditing.value,
                );
              }),

              const SizedBox(height: 12),

              _Field(
                controller: c.emailCtrl,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
                enabled: c.isEditing.value,
              ),
              const SizedBox(height: 12),

              _Field(
                controller: c.phoneCtrl,
                hint: "Phone",
                keyboardType: TextInputType.phone,
                enabled: c.isEditing.value,
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (!c.isEditing.value || c.isSaving.value)
                      ? null
                      : () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          try {
                            await c.save();
                            Get.snackbar(
                              "Saved",
                              "Personal details updated",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } catch (_) {
                            Get.snackbar(
                              "Error",
                              c.error.value.isEmpty
                                  ? "Update failed"
                                  : c.error.value,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    c.isSaving.value ? "Saving..." : "Save",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
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
                        onConfirm: () async {
                          Get.back();
                          try {
                            await c.deactivate();
                            Get.snackbar(
                              "Account",
                              "Account deactivated successfully",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } catch (_) {
                            Get.snackbar(
                              "Error",
                              c.error.value.isEmpty
                                  ? "Delete failed"
                                  : c.error.value,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                      barrierDismissible: true,
                    );
                  },
                  child: Text(
                    "Delete account permanently",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      letterSpacing: 0,
                      color: _C.green,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
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
                child: Icon(Icons.edit_rounded, size: 18, color: _C.green),
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
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final String? suffixText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool enabled;

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
            enabled: enabled,
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

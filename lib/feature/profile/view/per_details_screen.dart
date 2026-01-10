import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ------------------------------------------------------------
/// Personal Details (UI like your screenshot) - GetX
/// - Top bar: back + title
/// - Avatar center with small green camera button
/// - 3 input fields (Name with 0/50 counter, Email, Phone)
/// - Green Save button
/// - "Delete account permanently" link
///
/// Usage:
/// Get.to(() => const PersonalDetailsScreen());
/// ------------------------------------------------------------

class PersonalDetailsController extends GetxController {
  final nameCtrl = TextEditingController(text: "Paschaloliver");
  final emailCtrl = TextEditingController(text: "Paschaloliver@example.com");
  final phoneCtrl = TextEditingController();

  final nameLen = 0.obs;

  @override
  void onInit() {
    super.onInit();
    nameLen.value = nameCtrl.text.length;
    nameCtrl.addListener(() => nameLen.value = nameCtrl.text.length);
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
                      child: Image.network(
                        "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=300&q=60",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 40, color: Color(0xFF777777)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: InkWell(
                      onTap: () {
                        // TODO: pick image
                        Get.snackbar("Photo", "Open camera/gallery", snackPosition: SnackPosition.BOTTOM);
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _C.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
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
                  Get.snackbar("Saved", "Personal details updated", snackPosition: SnackPosition.BOTTOM);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Colors.white),
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
                        Get.snackbar("Account", "Delete requested", snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                child: const Text(
                  "Delete account permanently",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _C.green,
                    decoration: TextDecoration.underline,
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

/// ---------------- UI WIDGETS ----------------

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

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
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _C.text),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _C.text)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.suffixText,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.line),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 8))],
      ),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: _C.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: _C.hint),
          border: InputBorder.none,
          counterText: "", // we show custom counter
          contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          suffixIcon: suffixText == null
              ? null
              : Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                suffixText!,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.hint),
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
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
          boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 22, offset: Offset(0, 12))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_forever_rounded, size: 34, color: _C.green),
            const SizedBox(height: 10),
            const Text(
              "Delete account?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _C.text),
            ),
            const SizedBox(height: 6),
            const Text(
              "This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: _C.hint, height: 1.25),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
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

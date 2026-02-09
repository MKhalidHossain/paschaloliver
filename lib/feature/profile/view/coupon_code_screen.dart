import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_service/api_client.dart';

/// ---------------------------------------------------------------------------
/// ✅ MY CODES (PROMO CODE) – like your screenshot (GetX)
/// - Top back + title
/// - Input (grey)
/// - Add button (disabled when empty, green when filled)
/// - Gift info card
/// - Empty state (tag icon + text)
///
/// Use:
/// Get.to(() => const MyCodesScreen());
/// ---------------------------------------------------------------------------

class MyCodesController extends GetxController {
  final promoCtrl = TextEditingController();
  final promo = "".obs;
  final isApplying = false.obs;
  late final ApiClient _api;

  bool get canAdd => promo.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiClient>();
    promoCtrl.addListener(() => promo.value = promoCtrl.text);
  }

  @override
  void onClose() {
    promoCtrl.dispose();
    super.onClose();
  }

  Future<void> addCode() async {
    final raw = promo.value.trim();
    if (raw.isEmpty) {
      Get.snackbar(
        "Promo code",
        "Please enter a promo code.",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }
    if (raw.length < 4) {
      Get.snackbar(
        "Promo code",
        "Promo code is too short.",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }
    final code = raw.toUpperCase();
    final valid = RegExp(r"^[A-Z0-9_-]+$").hasMatch(code);
    if (!valid) {
      Get.snackbar(
        "Promo code",
        "Use only letters, numbers, - or _.",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }

    try {
      isApplying.value = true;
      final res = await _api.post(
        ApiEndpoints.applyCoupon,
        data: {"code": code},
      );
      final body = res.data as Map<String, dynamic>? ?? {};
      final success = body["success"] == true;
      final message = (body["message"] ?? body["data"]?["message"] ?? "")
          .toString();
      if (!success) {
        throw Exception(message.isEmpty ? "Apply coupon failed" : message);
      }

      promoCtrl.clear();
      Get.snackbar(
        "Promo code",
        message.isEmpty ? "Coupon added successfully" : message,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } catch (e) {
      String msg = e.toString().replaceFirst("Exception: ", "");
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          msg =
              (data["message"] ?? data["error"] ?? msg)
                  .toString()
                  .trim()
                  .isEmpty
              ? msg
              : (data["message"] ?? data["error"]).toString();
        }
      }
      Get.snackbar(
        "Promo code",
        msg,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } finally {
      isApplying.value = false;
    }
  }
}

class MyCodesScreen extends StatelessWidget {
  const MyCodesScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF8B8B8B);
  static const Color _line = Color(0xFFEDEDED);
  static const Color _field = Color(0xFFE6E6E6);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyCodesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          children: [
            // Top bar (Back + title)
            Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "My codes",
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700, // Bold
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Input
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _field,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _line),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: c.promoCtrl,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF727272),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintText: "Enter promo code",
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.1,
                    letterSpacing: 0,
                    color: const Color(0xFF727272),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Add button (disabled / enabled)
            Obx(() {
              final enabled = c.canAdd;
              final loading = c.isApplying.value;
              return SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enabled && !loading ? c.addCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enabled ? _green : _field,
                    disabledBackgroundColor: _field,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    loading ? "Adding..." : "Add",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      letterSpacing: 0,
                      color: enabled ? Colors.white : const Color(0xFF3D3E40),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),

            // Gift info card
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                color: _green.withOpacity(.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _green.withOpacity(.18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gift icon
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child: Image.asset(
                        Images.giftIcon,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Do you want a \$10 discount?",
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w500, // Medium
                            height: 1.1, // 110%
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Share the app with your friends and earn \$10 when\nthey make their first booking!",
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w400, // Regular
                            height: 1.1, // 110%
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // Empty state (tag icon)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Image.asset(
                        Images.keyIcon,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    "When you add a promotional code, it will\nappear here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: _text,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

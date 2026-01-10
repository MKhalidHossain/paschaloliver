import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  bool get canAdd => promo.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    promoCtrl.addListener(() => promo.value = promoCtrl.text);
  }

  @override
  void onClose() {
    promoCtrl.dispose();
    super.onClose();
  }

  void addCode() {
    final code = promo.value.trim();
    if (code.isEmpty) return;

    // TODO: call API / save locally
    Get.snackbar(
      "Promo code",
      "Added: $code",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.black.withOpacity(.75),
      colorText: Colors.white,
    );
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
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _text),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "My codes",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: _text),
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
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _text),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintText: "Enter promo code",
                  hintStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _muted),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Add button (disabled / enabled)
            Obx(() {
              final enabled = c.canAdd;
              return SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enabled ? c.addCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: enabled ? _green : _field,
                    disabledBackgroundColor: _field,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: enabled ? Colors.white : _muted,
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
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _green.withOpacity(.20)),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, size: 18, color: _green),
                  ),
                  const SizedBox(width: 10),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Do you want a ₦10 discount?",
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: _text),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Share the app with your friends and earn ₦10 when\nthey make their first booking!",
                          style: TextStyle(fontSize: 10.8, fontWeight: FontWeight.w700, color: _muted, height: 1.25),
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
                    child: Icon(Icons.local_offer_outlined, size: 78, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    "When you add a promotional code, it will\nappear here",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _text, height: 1.35),
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

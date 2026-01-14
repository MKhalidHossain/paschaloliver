import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';

/// ✅ Payment Methods (Empty state) — UI like your screenshot
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const Color _green = Color(0xFF2FA86A);
  static const Color _text = Color(0xFF1F1F1F);
  static const Color _muted = Color(0xFF727272);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _text,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _green),
        ),
        title: Text(
          "Payment methods",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold
            height: 1.1, // 110%
            letterSpacing: 0,
            color: const Color(0xFF000000),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add new payment method
              // Get.to(() => const AddPaymentMethodScreen());
            },
            icon: const Icon(Icons.add, color: _green),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Text(
                  "No Payment methods",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.2, // 120%
                    letterSpacing: 0,
                    color: const Color(0xFF727272),
                  ),
                ),


                const SizedBox(height: 18),

                // ✅ Illustration (replace with your asset)
                Image.asset(
                  Images.paymentEmptyIcon,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),


                const SizedBox(height: 18),

                Text(
                  "You haven't any payment\nmethod yet",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 22,
                    fontWeight: FontWeight.w500, // Medium
                    height: 1.2, // 120%
                    letterSpacing: 0,
                    color: const Color(0xFF727272),
                  ),
                ),


                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: go to add payment method screen
                      // Get.to(() => const AddPaymentMethodScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: Text(
                      "Add new payment methods",
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

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

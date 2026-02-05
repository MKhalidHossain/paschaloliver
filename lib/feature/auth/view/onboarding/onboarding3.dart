import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import '../welcome_screen.dart';
import 'onboarding4.dart';

class HandyOnboardingPerformServicesScreen extends StatelessWidget {
  const HandyOnboardingPerformServicesScreen({super.key});

  Color get _brandGreen => const Color(0xFF27AE60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------------- TOP ROW: EXIT ----------------
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(
                        () => const WelcomeScreenView(),
                      ); // clears stack
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: 14,
                        color: _brandGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ---------------- ILLUSTRATION + TEXT ----------------
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: Image.asset(
                        Images.onboarding3,
                        // TODO: change to your real asset path
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // -------------- TITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Perform the services',
                        style: GoogleFonts.urbanist(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.1, // 110%
                          letterSpacing: 0, // 0%
                          color: const Color(0xFF000000), // or _textColor
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // -------------- SUBTITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Complete the services for which you have been booked.',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ---------------- PAGE INDICATORS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true, color: _brandGreen), // step 3
                  _buildDot(isActive: false),
                ],
              ),

              const SizedBox(height: 18),

              // ---------------- NEXT BUTTON ----------------
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: go to final onboarding / dashboard
                    Get.to(() => const HandyOnboardingEarnMoneyScreen());
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- helper for indicator dots ----------
  Widget _buildDot({required bool isActive, Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? (color ?? Colors.black) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

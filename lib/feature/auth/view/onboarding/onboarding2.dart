import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import '../welcome_screen.dart';
import 'onboarding3.dart';

class HandyOnboardingGetCustomersScreen extends StatelessWidget {
  const HandyOnboardingGetCustomersScreen({super.key});

  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _textColor => const Color(0xFF222222);

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
                        Images.onboarding2,
                        // TODO: change to your real asset path
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // -------------- TITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get Customers',
                        style: GoogleFonts.urbanist(
                          fontSize: 32, // Figma size
                          fontWeight: FontWeight.w700, // Bold 700
                          height: 1.1, // 110%
                          letterSpacing: 0,
                          color: _textColor, // or Color(0xFF000000)
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // -------------- SUBTITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Service requests for customers or actively apply\n'
                        'for job leads.',
                        style: GoogleFonts.urbanist(
                          fontSize: 16, // Figma size
                          fontWeight: FontWeight.w400, // Regular 400
                          height: 1.1, // 110% line height
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
                  _buildDot(isActive: false), // step 1
                  _buildDot(
                    isActive: true, // step 2 active
                    color: _brandGreen,
                  ),
                  _buildDot(isActive: false),
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
                    // TODO: go to next onboarding screen
                    Get.to(() => const HandyOnboardingPerformServicesScreen());
                  },
                  child: Text(
                    'Next',
                    style: GoogleFonts.urbanist(
                      fontSize: 16, // 16px
                      fontWeight: FontWeight.w500, // Medium
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFFFFFFFF),
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

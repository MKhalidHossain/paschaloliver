import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import '../welcome_screen.dart';
import 'onboarding2.dart';

class HandyOnboardingAtHomeScreen extends StatelessWidget {
  const HandyOnboardingAtHomeScreen({super.key});

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

              // ---------------- ILLUSTRATION ----------------
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: Image.asset(
                        Images.offersIcon,
                        // TODO: change to your real asset path
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // -------------- TITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Offer your at-home\nservices',
                        style: GoogleFonts.urbanist(
                          fontSize: 32, // Figma size
                          fontWeight: FontWeight.w700, // Bold 700
                          height: 1.1, // 110%
                          letterSpacing: 0,
                          color: const Color(
                            0xFF000000,
                          ), // or _textColor if it's black
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // -------------- SUBTITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let us know where you can travel to, when you're "
                        "available, and what services you want to offer.",
                        style: GoogleFonts.urbanist(
                          fontSize: 16, // Figma: 16px
                          fontWeight: FontWeight.w400, // Regular
                          height: 1.1, // 110%
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
                  _buildDot(isActive: true, color: _brandGreen),
                  _buildDot(isActive: false),
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
                    Get.to(() => const HandyOnboardingGetCustomersScreen());
                  },
                  child: Text(
                    'Next',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium 500
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

  // small helper for page indicator dots
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

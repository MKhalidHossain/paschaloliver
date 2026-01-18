import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import 'onboarding1.dart';

class BecomeProfessionalScreen extends StatelessWidget {
  const BecomeProfessionalScreen({super.key});

  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _textColor => const Color(0xFF222222);
  Color get _bg => Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      // ----------------- CUSTOM APP BAR -----------------
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: _bg,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: _brandGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 18, color: Colors.grey.shade300),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Become a professional',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ----------------- BODY -----------------
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ----------- TITLE & SUBTITLE -----------
              Text(
                'Want to offer your services \non HandyNaija?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.2, // 120%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                'Create your professional profile and start \nearning money',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 16, // Figma size: 16px
                  fontWeight: FontWeight.w400, // Regular
                  height: 1.1, // Line height 110%
                  letterSpacing: 0,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 24),

              // ----------- ILLUSTRATION -----------
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1, // 375 × 375 style square
                    child: Image.asset(
                      Images.men,
                      // TODO: change to your real asset path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ----------- CTA BUTTON -----------
              SizedBox(
                width: double.infinity,
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
                    // TODO: navigate to professional profile flow
                    Get.to(() => const HandyOnboardingAtHomeScreen());
                  },
                  child: Text(
                    'Become a professional',
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
}

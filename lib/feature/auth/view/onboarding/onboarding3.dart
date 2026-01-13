import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets.dart';
import '../welcome_screen.dart';
import 'onboarding4.dart';

class HandyOnboardingPerformServicesScreen extends StatelessWidget {
  const HandyOnboardingPerformServicesScreen({super.key});

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
                      Get.offAll(() => const WelcomeScreenView()); // clears stack
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
                        style: TextStyle(
                          fontSize: 26,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // -------------- SUBTITLE --------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Complete the services for which you have been '
                            'booked.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey.shade700,
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

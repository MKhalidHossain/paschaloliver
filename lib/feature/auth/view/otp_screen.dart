import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/auth/view/reset_password_screen.dart';

import '../../../core/constants/assets.dart';

class HandyOtpScreen extends StatefulWidget {
  const HandyOtpScreen({super.key});

  @override
  State<HandyOtpScreen> createState() => _HandyOtpScreenState();
}

class _HandyOtpScreenState extends State<HandyOtpScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _textColor => const Color(0xFF222222);

  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      // move to next box
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // backspace → go previous
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp =>
      _controllers.map((e) => e.text.trim()).join(); // full OTP string

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, paddingTop + 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------- LOGO ----------------
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: Image.asset(
                  Images.appLogo, // 🔁 change path to your logo
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              // Text(
              //   'HandyNaija',
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.w700,
              //     color: _brandGreen,
              //     letterSpacing: 0.3,
              //   ),
              // ),
              // const SizedBox(height: 24),

              // ---------------- TITLE & SUBTITLE ----------------
              SizedBox(
                width: 343,
                height: 31,
                child: Center(
                  child: Text(
                    'OTP',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.w600, // ✅ SemiBold
                      height: 1.1, // ✅ 110%
                      letterSpacing: 0,
                      color: const Color(0xFF123055), // ✅ #123055
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),
              SizedBox(
                width: 343,
                height: 36,
                child: Text(
                  'We have sent the verification code to your email \naddress',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.1, // 110%
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- OTP BOXES ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: SizedBox(
                      width: 55,
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _brandGreen,
                              width: 1.4,
                            ),
                          ),
                        ),
                        onChanged: (val) => _onOtpChanged(val, index),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // ---------------- RESEND TEXT ----------------
              SizedBox(
                width: 343,
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // ✅ Right
                  crossAxisAlignment: CrossAxisAlignment.center, // ✅ Middle
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Didn't get the code ? ",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400, // ✅ Regular
                        height: 1.1, // ✅ 110%
                        letterSpacing: 0,
                        color: const Color(0xFF181919), // use your figma color
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: resend
                      },
                      child: Text(
                        "Resend it.",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w400, // ✅ Regular (Figma = 14 Regular)
                          height: 1.1,
                          letterSpacing: 0,
                          color: _brandGreen, // or figma color if different
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- CONTINUE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final code = _otp; // e.g. "8523"

                    // (optional) basic validation
                    if (code.length != 4) {
                      Get.snackbar(
                        'Invalid code',
                        'Please enter the 4-digit code.',
                        snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    // ✅ Navigate to reset password screen with GetX
                    Get.to(() => const HandyResetPasswordScreen());
                    // If you want to pass the code:
                    // Get.to(() => const HandyResetPasswordScreen(), arguments: code);
                  },

                  child: const Text(
                    'Continue',
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
}

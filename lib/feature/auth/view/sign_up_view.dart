import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/feature/auth/view/sign_in_view.dart';

import '../../../core/constants/assets.dart';
import 'onboarding/become_professional.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // controllers (optional – use if you need values)
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _fieldBorder => const Color(0xFFDDDDDD);
  Color get _hintColor => const Color(0xFFB9B9B9);
  Color get _textColor => const Color(0xFF222222);

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
              // ------------------ Logo ------------------
              const SizedBox(height: 8),
              // Replace with your logo
              SizedBox(
                height: 90,
                child: Image.asset(
                  Images.appLogo, // TODO: change path
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),


              const SizedBox(height: 24),

              // ------------------ Title & subtitle ------------------
              Text(
                'Create New Account',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF123055),
                ),
              ),

              const SizedBox(height: 4),
              Text(
                'Sign up to get started',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.1, // 110%
                  letterSpacing: 0,
                  color: const Color(0xFF181919),
                ),
              ),

              const SizedBox(height: 24),

              // ------------------ Form fields ------------------
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _fullNameCtrl,
                hint: 'Festus Okonkwo',
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              _buildLabel('Email Address'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _emailCtrl,
                hint: 'you@gmail.com',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildLabel('Password'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _passwordCtrl,
                obscure: _obscurePassword,
                onToggle: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 16),

              _buildLabel('Confirm Password'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _confirmPasswordCtrl,
                obscure: _obscureConfirmPassword,
                onToggle: () {
                  setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
              const SizedBox(height: 24),

              // ------------------ Create account button ------------------
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
                    Get.to(() => const BecomeProfessionalScreen());
                  },

                  child: const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ------------------ Divider “or” ------------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ------------------ Social buttons ------------------
              _SocialButton(
                text: 'Continue with Facebook',
                backgroundColor: const Color(0xFF1877F2),
                textColor: Colors.white,
                borderColor: Colors.transparent,
                icon: Image.asset(
                  Images.facebook, // TODO: change path
                  height: 20,
                  width: 20,
                ),
                onTap: () {
                  // TODO: facebook login
                },
              ),
              const SizedBox(height: 12),

              _SocialButton(
                text: 'Continue with Google',
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: Colors.grey.shade300,
                icon: Image.asset(
                  Images.google, // TODO: change path
                  height: 18,
                  width: 18,
                ),
                onTap: () {
                  // TODO: google login
                },
              ),
              const SizedBox(height: 12),

              _SocialButton(
                text: 'Continue with Apple',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                borderColor: Colors.transparent,
                icon: Image.asset(
                  Images.apple, // TODO: change path
                  height: 20,
                  width: 20,
                  color: Colors.white,
                ),
                onTap: () {
                  // TODO: apple login
                },
              ),
              const SizedBox(height: 24),

              // ------------------ Already have account ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const HandyEmailLoginScreen());
                    },

                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _brandGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w500, // Medium
          height: 1.1, // 110%
          letterSpacing: 0,
          color: const Color(0xFF181919),
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType textInputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w400, // Regular
          height: 1.1, // 110%
          letterSpacing: 0,
          color: const Color(0xFF727272),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _brandGreen, width: 1.4),
        ),
      ),
    );
  }


  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: '***************',
        hintStyle: TextStyle(
          fontSize: 13,
          color: _hintColor,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: Colors.grey.shade500,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _brandGreen, width: 1.4),
        ),
      ),
    );
  }
}

// ------------------ Social Button Widget ------------------
class _SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min, // ✅ icon+text stay together
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


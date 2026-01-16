import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_ground.dart';
import '../../../core/constants/assets.dart';
import '../../user/app_ground_user.dart';
import 'forget_password.dart';

class HandyEmailLoginScreen extends StatefulWidget {
  const HandyEmailLoginScreen({super.key});

  @override
  State<HandyEmailLoginScreen> createState() => _HandyEmailLoginScreenState();
}

class _HandyEmailLoginScreenState extends State<HandyEmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  Color get _green => const Color(0xFF19A94A);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // void _submit() {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   final email = _emailCtrl.text.trim();
  //   final password = _passwordCtrl.text.trim();
  //   final remember = _rememberMe;
  //
  //   debugPrint('Login -> email: $email | remember: $remember');
  //
  //   Get.offAll(() => const AppGround()); // removes login screen from stack
  // }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim().toLowerCase();
    final password = _passwordCtrl.text.trim();
    final remember = _rememberMe;

    debugPrint('Login -> email: $email | remember: $remember');

    // ✅ route by email
    if (email == "professional@gmail.com") {
      Get.offAll(() => const AppGround());
    } else if (email == "user@gmail.com") {
      Get.offAll(() => const UserAppGround());
    } else {
      // ✅ fallback (choose what you want)
      Get.snackbar(
        "Login",
        "Unknown user type for: $email",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background illustration
          Positioned.fill(
            child: Image.asset(Images.welcome, fit: BoxFit.cover),
          ),

          // gradient overlay for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),

          // ✅ SafeArea: remove bottom padding so sheet can go to the very bottom
          SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [const Spacer(), _buildBottomSheet(context)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    // ✅ system bottom inset (home indicator area)
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      // ✅ extend background under the home indicator, keep content above it
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),

            // header row
            Row(
              children: [
                SizedBox(
                  width: 57,
                  height: 26,
                  child: Align(
                    alignment: Alignment.centerRight, // ✅ Figma: Right
                    child: Text(
                      'Login',
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w500, // ✅ Medium (500)
                        height: 1.1, // ✅ 110%
                        letterSpacing: 0,
                        color: const Color(0xFF181919), // ✅ #181919
                      ),
                    ),
                  ),
                ),

                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.close, size: 22, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                hintText: 'you@gmail.com',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: _outlineBorder(),
                enabledBorder: _outlineBorder(),
                focusedBorder: _outlineBorder(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '****************',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: _outlineBorder(),
                enabledBorder: _outlineBorder(),
                focusedBorder: _outlineBorder(
                  color: Colors.black.withOpacity(0.8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Remember / Forgot
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  visualDensity: VisualDensity.compact,
                  activeColor: const Color(0xFF3FA96B), // ✅ green when checked
                  checkColor: Colors.white, // ✅ tick color
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _rememberMe = v);
                  },
                ),

                const SizedBox(width: 2),
                const Text(
                  'Remember me',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    // 👈 change here
                    Get.to(() => const HandyForgotPasswordScreen());
                  },

                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Log in button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Log in',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // ✅ Figma 500
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: Colors.white, // ✅ #FFFFFF
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? const Color(0xFFDDDDDD), width: 1),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';

import '../../../core/constants/assets.dart';
import '../../../core/network/api_service/api_client.dart';
import '../services/auth_interface.dart';
import '../services/auth_interface_impl.dart';
import 'otp_screen.dart';
import 'sign_in_view.dart';

class HandyForgotPasswordScreen extends StatefulWidget {
  const HandyForgotPasswordScreen({super.key});

  @override
  State<HandyForgotPasswordScreen> createState() =>
      _HandyForgotPasswordScreenState();
}

class _HandyForgotPasswordScreenState extends State<HandyForgotPasswordScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _borderColor => const Color(0xFFDDDDDD);

  bool _emailSelected = true;
  bool _isLoading = false;

  late final AuthInterface _auth;
  late final String _email;

  @override
  void initState() {
    super.initState();

    _email = (Get.arguments is String) ? (Get.arguments as String) : "";

    // If email not provided, go back to login
    if (_email.trim().isEmpty) {
      Future.microtask(() => Get.offAll(() => const HandyEmailLoginScreen()));
      return;
    }

    final ApiClient api = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put(ApiClient(ApiEndpoints.baseUrl), permanent: true);

    _auth = Get.isRegistered<AuthInterface>()
        ? Get.find<AuthInterface>()
        : Get.put<AuthInterface>(AuthInterfaceImpl(api), permanent: true);
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      await _auth.forgotPassword(email: _email.trim());

      Get.snackbar(
        "Success",
        "OTP sent to your email",
        snackPosition: SnackPosition.TOP,
      );

      Get.to(() => const HandyOtpScreen(), arguments: _email.trim());
    } catch (e) {
      Get.snackbar(
        "Failed",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 3) return "***@$domain";
    return "${name.substring(0, 3)}***@$domain";
  }

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
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: Image.asset(Images.appLogo, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 24),

              SizedBox(
                width: 343,
                height: 31,
                child: Center(
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: const Color(0xFF123055),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),
              SizedBox(
                width: 343,
                height: 36,
                child: Text(
                  'Select which contact details should we use to \nreset your password',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: const Color(0xFF181919),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => setState(() => _emailSelected = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _emailSelected ? _brandGreen : _borderColor,
                      width: _emailSelected ? 1.4 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                        color: Colors.black.withAlpha(8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFF5F5F5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mail_outline_rounded,
                            size: 22,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Via Email:',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                                color: const Color(0xFF727272),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _maskEmail(_email),
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                                color: const Color(0xFF181919),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remember Password ',
                    style: TextStyle(fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Get.offAll(() => const HandyEmailLoginScreen()),
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
}

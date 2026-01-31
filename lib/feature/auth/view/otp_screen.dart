import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';

import '../../../core/constants/assets.dart';
import '../../../core/network/api_service/api_client.dart';
import '../services/auth_interface.dart';
import '../services/auth_interface_impl.dart';
import 'reset_password_screen.dart';

class HandyOtpScreen extends StatefulWidget {
  const HandyOtpScreen({super.key});

  @override
  State<HandyOtpScreen> createState() => _HandyOtpScreenState();
}

class _HandyOtpScreenState extends State<HandyOtpScreen> {
  Color get _brandGreen => const Color(0xFF27AE60);

  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

  late final AuthInterface _auth;
  late final String _email;

  @override
  void initState() {
    super.initState();

    _email = (Get.arguments is String) ? (Get.arguments as String) : "";

    final ApiClient api = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put(ApiClient(ApiEndpoints.baseUrl), permanent: true);

    _auth = Get.isRegistered<AuthInterface>()
        ? Get.find<AuthInterface>()
        : Get.put<AuthInterface>(AuthInterfaceImpl(api), permanent: true);
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp => _controllers.map((e) => e.text.trim()).join();

  Future<void> _verifyOtp() async {
    final code = _otp;
    if (code.length != 4) {
      Get.snackbar(
        'Invalid code',
        'Please enter the 4-digit code.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.verifyEmail(email: _email.trim(), otp: code);

      Get.snackbar("Success", "OTP verified", snackPosition: SnackPosition.TOP);

      Get.to(() => const HandyResetPasswordScreen(), arguments: _email.trim());
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

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      await _auth.forgotPassword(email: _email.trim());
      Get.snackbar("Success", "OTP resent", snackPosition: SnackPosition.TOP);
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
              const SizedBox(height: 12),

              SizedBox(
                width: 343,
                height: 31,
                child: Center(
                  child: Text(
                    'OTP',
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
                  'We have sent the verification code to your email \naddress',
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

              const SizedBox(height: 28),

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

              SizedBox(
                width: 343,
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Didn't get the code ? ",
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                        color: const Color(0xFF181919),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : _resendOtp,
                      child: Text(
                        "Resend it.",
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                          color: _brandGreen,
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: _isLoading ? null : _verifyOtp,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
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

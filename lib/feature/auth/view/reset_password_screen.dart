import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/auth/view/sign_in_view.dart';
import '../../../core/constants/assets.dart';

class HandyResetPasswordScreen extends StatefulWidget {
  const HandyResetPasswordScreen({super.key});

  @override
  State<HandyResetPasswordScreen> createState() =>
      _HandyResetPasswordScreenState();
}

class _HandyResetPasswordScreenState extends State<HandyResetPasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _newError;
  String? _confirmError;

  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _fieldBorder => const Color(0xFFDDDDDD);
  Color get _textColor => const Color(0xFF222222);
  Color get _hintColor => const Color(0xFFB9B9B9);

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // ✅ YOUR SNACKBAR STYLE (TOP)
  void _showSnack({
    required String title,
    required String message,
  }) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
    );
  }

  bool _validate() {
    final newPass = _newPassCtrl.text.trim();
    final confirm = _confirmPassCtrl.text.trim();

    String? newErr;
    String? confirmErr;

    if (newPass.isEmpty) {
      newErr = "Please enter a new password";
    } else if (newPass.length < 6) {
      newErr = "Password must be at least 6 characters";
    }

    if (confirm.isEmpty) {
      confirmErr = "Please confirm your password";
    } else if (newPass != confirm) {
      confirmErr = "Passwords do not match";
    }

    setState(() {
      _newError = newErr;
      _confirmError = confirmErr;
    });

    return newErr == null && confirmErr == null;
  }

  void _onContinue() {
    if (!_validate()) {
      // ✅ shows TOP snackbar
      _showSnack(
        title: "Invalid input",
        message: "Please fix the highlighted fields and try again.",
      );
      return; // ✅ NO navigation
    }

    _showSnack(
      title: "Success",
      message: "Password updated successfully.",
    );

    // ✅ navigate to sign in only if valid
    Get.offAll(() => const HandyEmailLoginScreen());
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
                child: Image.asset(
                  Images.appLogo,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              // Text(
              //   'HandyNaija',
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.w700,
              //     color: _brandGreen,
              //     letterSpacing: 0.3,
              //   ),
              // ),
              // const SizedBox(height: 28),

              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 28),

              _buildLabel('New Password'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _newPassCtrl,
                obscure: _obscureNew,
                errorText: _newError,
                onChanged: (_) {
                  if (_newError != null) setState(() => _newError = null);
                },
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 18),

              _buildLabel('Confirm New Password'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _confirmPassCtrl,
                obscure: _obscureConfirm,
                errorText: _confirmError,
                onChanged: (_) {
                  if (_confirmError != null) setState(() => _confirmError = null);
                },
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 28),

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
                  onPressed: _onContinue,
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required ValueChanged<String> onChanged,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
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
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

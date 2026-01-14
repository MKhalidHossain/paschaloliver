import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// ✅ FULL REPLACEABLE: ChangePasswordScreen (matches screenshot)
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Figma-like colors
  static const Color _text = Color(0xFF181919);
  static const Color _muted = Color(0xFF727272);
  static const Color _border = Color(0xFFE6E6E6);
  static const Color _shadow = Color(0x14000000); // subtle

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: API call
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Top bar: back + title (like screenshot)
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: _text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Change Password",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700, // Bold
                      height: 1.1, // 110%
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 22),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _Label("Current Password"),
                    const SizedBox(height: 8),
                    _PasswordField(
                      controller: _currentCtrl,
                      obscure: _obscureCurrent,
                      onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      hint: "************",
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Current password required";
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    _Label("New Password"),
                    const SizedBox(height: 8),
                    _PasswordField(
                      controller: _newCtrl,
                      obscure: _obscureNew,
                      onToggle: () => setState(() => _obscureNew = !_obscureNew),
                      hint: "************",
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "New password required";
                        if (v.trim().length < 6) return "Minimum 6 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    _Label("Confirm Password"),
                    const SizedBox(height: 8),
                    _PasswordField(
                      controller: _confirmCtrl,
                      obscure: _obscureConfirm,
                      onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      hint: "************",
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Confirm password required";
                        if (v.trim() != _newCtrl.text.trim()) return "Password does not match";
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              // ✅ keep big white space like screenshot
              // const Spacer(),

              // Optional button (not in your screenshot)
              // Uncomment if you need it.

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FA86A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Update",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  static const Color _text = Color(0xFF181919);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.1,
          color: _text,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.hint,
    required this.validator,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String hint;
  final String? Function(String?) validator;

  static const Color _text = Color(0xFF181919);
  static const Color _muted = Color(0xFF727272);
  static const Color _border = Color(0xFFE6E6E6);
  static const Color _shadow = Color(0x14000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: _shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.1,
          color: _text,
        ),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.1,
            color: _muted.withOpacity(.55),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: _muted,
            ),
          ),
        ),
      ),
    );
  }
}

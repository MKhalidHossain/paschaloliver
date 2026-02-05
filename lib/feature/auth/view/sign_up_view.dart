import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/feature/auth/models/login_request_model.dart';
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';
import '../../../core/constants/assets.dart';
import '../../../core/network/api_service/api_client.dart';
import '../controller/role_controller.dart';
import '../services/auth_interface.dart';
import '../services/auth_interface_impl.dart';
import 'onboarding/become_professional.dart';
import 'sign_in_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _fieldBorder => const Color(0xFFDDDDDD);
  Color get _hintColor => const Color(0xFFB9B9B9);

  late final RoleController _roleC;
  late final AuthInterface _auth;

  @override
  void initState() {
    super.initState();

    _roleC = Get.isRegistered<RoleController>()
        ? Get.find<RoleController>()
        : Get.put(RoleController(), permanent: true);

    if (!Get.isRegistered<ApiClient>()) {
      // ApiClient expects baseUrl string (your ApiEndpoints.baseUrl already includes /api/v1)
      Get.put<ApiClient>(ApiClient(ApiEndpoints.baseUrl), permanent: true);
    }

    if (!Get.isRegistered<AuthInterface>()) {
      Get.put<AuthInterface>(
        AuthInterfaceImpl(Get.find<ApiClient>()),
        permanent: true,
      );
    }

    _auth = Get.find<AuthInterface>();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final name = _fullNameCtrl.text.trim();
      final email = _emailCtrl.text.trim().toLowerCase();
      final password = _passwordCtrl.text.trim();

      final roleRaw = _roleC.selectedRole.value.trim().toLowerCase();
      final role = roleRaw.isEmpty
          ? 'client'
          : roleRaw; // client | professional

      final userId = await _auth.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (userId != null && userId.isNotEmpty) {
        await TokenManager.saveUid(userId);
      }

      if (role == 'professional') {
        await _auth.login(
          LoginRequestModel(
            email: email,
            password: password,
          ),
        );
      }

      // ✅ FIX: role-based navigation ONLY
      if (role == 'client') {
        Get.offAll(() => const HandyEmailLoginScreen());
      } else {
        Get.offAll(() => const BecomeProfessionalScreen());
      }
    } catch (e) {
      Get.snackbar(
        "Sign up failed",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
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
          child: Form(
            key: _formKey,
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

                Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
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
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    letterSpacing: 0,
                    color: const Color(0xFF181919),
                  ),
                ),
                const SizedBox(height: 24),

                _buildLabel('Full Name'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _fullNameCtrl,
                  hint: 'Festus Okonkwo',
                  textInputType: TextInputType.name,
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return "Full name is required";
                    if (value.length < 3) return "Enter a valid name";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Email Address'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailCtrl,
                  hint: 'you@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return "Email is required";
                    if (!_isValidEmail(value)) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Password'),
                const SizedBox(height: 6),
                _buildPasswordField(
                  controller: _passwordCtrl,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return "Password is required";
                    if (value.length < 6) return "Min 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Confirm Password'),
                const SizedBox(height: 6),
                _buildPasswordField(
                  controller: _confirmPasswordCtrl,
                  obscure: _obscureConfirmPassword,
                  onToggle: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return "Confirm password is required";
                    if (value != _passwordCtrl.text.trim()) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
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
                    onPressed: _isLoading ? null : _register,
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
                            'Create New Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const HandyEmailLoginScreen()),
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
          fontWeight: FontWeight.w500,
          height: 1.1,
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.1,
          letterSpacing: 0,
          color: const Color(0xFF727272),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: '***************',
        hintStyle: TextStyle(fontSize: 13, color: _hintColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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

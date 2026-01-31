import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';

import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/core/network/api_service/api_endpoints.dart';
import 'package:paschaloliver/feature/auth/services/auth_interface.dart';
import 'package:paschaloliver/feature/auth/services/auth_interface_impl.dart';

import '../../../app_ground.dart';
import '../../../core/constants/assets.dart';
import '../../user/app_ground_user.dart';
import '../controller/login_controller.dart';
import 'forget_password.dart';

class HandyEmailLoginScreen extends StatefulWidget {
  const HandyEmailLoginScreen({super.key});

  @override
  State<HandyEmailLoginScreen> createState() => _HandyEmailLoginScreenState();
}

class _HandyEmailLoginScreenState extends State<HandyEmailLoginScreen> {
  static const Color _green = Color(0xFF19A94A);

  static const OutlineInputBorder _baseBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1),
  );

  OutlineInputBorder _outlineBorder({Color? color}) {
    if (color == null) return _baseBorder;
    return _baseBorder.copyWith(borderSide: BorderSide(color: color, width: 1));
  }

  late final LoginController c;
  late final String _tag; // ✅ unique tag so controller is unique per screen

  @override
  void initState() {
    super.initState();

    // ✅ 1) ApiClient (singleton is OK)
    final ApiClient api = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put(ApiClient(ApiEndpoints.baseUrl), permanent: true);

    // ✅ 2) AuthInterface (singleton is OK)
    final AuthInterface auth = Get.isRegistered<AuthInterface>()
        ? Get.find<AuthInterface>()
        : Get.put<AuthInterface>(AuthInterfaceImpl(api), permanent: true);

    // ✅ 3) LoginController MUST be unique per screen instance
    _tag = DateTime.now().microsecondsSinceEpoch.toString();
    c = Get.put(LoginController(auth), tag: _tag);
  }

  @override
  void dispose() {
    // ✅ delete controller so its GlobalKey is not reused anywhere
    if (Get.isRegistered<LoginController>(tag: _tag)) {
      Get.delete<LoginController>(tag: _tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.welcome, fit: BoxFit.cover),
          ),
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
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Form(
        key: c.formKey, // ✅ safe now (unique controller)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),

            Row(
              children: [
                SizedBox(
                  width: 57,
                  height: 26,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Login',
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        letterSpacing: 0,
                        color: const Color(0xFF181919),
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
              controller: c.emailCtrl,
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
                final v = value?.trim() ?? "";
                if (v.isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),

            const SizedBox(height: 16),

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

            Obx(() {
              return TextFormField(
                controller: c.passwordCtrl,
                obscureText: c.obscurePassword.value,
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
                      c.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: c.togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  final v = value ?? "";
                  if (v.isEmpty) return 'Please enter your password';
                  if (v.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
              );
            }),

            const SizedBox(height: 12),

            Row(
              children: [
                Obx(() {
                  return Checkbox(
                    value: c.rememberMe.value,
                    visualDensity: VisualDensity.compact,
                    activeColor: const Color(0xFF3FA96B),
                    checkColor: Colors.white,
                    onChanged: (v) {
                      if (v == null) return;
                      c.toggleRemember(v);
                    },
                  );
                }),
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
                  onPressed: () => Get.to(
                    () => const HandyForgotPasswordScreen(),
                    arguments: c.emailCtrl.text.trim(), // ✅ pass email
                  ),
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

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: c.isLoading.value
                      ? null
                      : () => c.submit(
                          goProfessional: () =>
                              Get.offAll(() => const AppGround()),
                          goUser: () => Get.offAll(() => const UserAppGround()),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: c.isLoading.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Log in',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/core/constants/app_colors.dart';


import '../../user/app_ground_user.dart';
import 'account_type_view.dart';
import 'sign_in_view.dart';

class LoginTypeView extends StatelessWidget {
  const LoginTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [_mainContent(), _bottomCard(context)],
        ),
      ),
    );
  }

  /// ===================== MAIN CONTENT =====================
  Widget _mainContent() {
    return Column(
      children: [
        Expanded(child: _illustration()),
        const SizedBox(height: 120),
      ],
    );
  }

  /// ===================== ILLUSTRATION =====================
  Widget _illustration() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image.asset(
        'assets/images/Wellcome.png',
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  /// ===================== BOTTOM CARD =====================
  Widget _bottomCard(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),
              _primaryButton(
                title: 'Create new account',
                color: AppColors.appColor,
                onTap: () => Get.to(() => ChooseAccountTypeView()),
              ),
              const SizedBox(height: 16),
              _primaryButton(
                title: 'Log in',
                color: const Color(0xFF0D1B3E),
                onTap: () => Get.to(() => HandyEmailLoginScreen()),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.to(() => UserAppGround()),
                child: const Text(
                  'Continue as a guest',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===================== BUTTON =====================
  Widget _primaryButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

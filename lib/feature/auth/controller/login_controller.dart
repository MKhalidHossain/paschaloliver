import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paschaloliver/feature/auth/models/login_request_model.dart';

import '../services/auth_interface.dart';

class LoginController extends GetxController {
  final AuthInterface auth;

  LoginController(this.auth);

  final formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  final isLoading = false.obs;

  

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRemember(bool value) {
    rememberMe.value = value;
  }

  Future<void> submit({
    required VoidCallback goProfessional,
    required VoidCallback goUser,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailCtrl.text.trim().toLowerCase();
    final password = passwordCtrl.text.trim();

    try {
      isLoading.value = true;

      final res = await auth.login(
        LoginRequestModel(email: email, password: password),
      );

      // route by role from API (best) OR fallback to email
      final role = res.data.user.role.toLowerCase();

      Get.snackbar("Login", res.message, snackPosition: SnackPosition.TOP);

      if (role == "professional") {
        goProfessional();
      } else if (role == "client" || role == "user") {
        goUser();
      }
      // } else {
      //   // fallback behavior
      //   goUser();
      // }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

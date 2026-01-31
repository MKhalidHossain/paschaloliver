import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';
import 'package:paschaloliver/feature/auth/models/login_request_model.dart';
import 'package:paschaloliver/feature/auth/models/login_response_model.dart';
import 'package:paschaloliver/feature/auth/models/switch_role_response_model.dart';

import '../../../core/constants/api_endpoints.dart';
import 'auth_interface.dart';

class AuthInterfaceImpl implements AuthInterface {
  final ApiClient api;

  AuthInterfaceImpl(this.api);

  @override
  Future<LoginApiResponse> login(LoginRequestModel params) async {
    try {
      final Response res = await api.post(
        ApiEndpoints.login,
        data: params.toJson(),
      );

      final body = res.data as Map<String, dynamic>;
      debugPrint("LOGIN RAW => $body");

      final parsed = LoginApiResponse.fromMap(body);

      // server says success?
      if (parsed.success != true) {
        throw Exception(
          parsed.message.isNotEmpty ? parsed.message : "Login failed",
        );
      }

      // Save auth (replace with SecureStorage later)
      await TokenManager.save(
        access: parsed.data.accessToken,
        refresh: parsed.data.refreshToken,
        uid: parsed.data.user.id.toString(),
        userName: parsed.data.user.name,
        userEmail: parsed.data.user.email,
        userRole: parsed.data.user.role,
      );

      return parsed;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ?? "Login error")
          : (e.message ?? "Login error");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final res = await api.post(
        ApiEndpoints.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": role, // ✅ important
        },
      );

      final data = res.data;
      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Registration failed");
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ?? "Registration failed")
          : (e.message ?? "Registration failed");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  // =======================
  // ✅ FORGOT PASSWORD FLOW
  // =======================

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final res = await api.post(
        ApiEndpoints.forgetPassword,
        data: {"email": email},
      );
      final data = res.data;
      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "OTP request failed");
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ?? "OTP request failed")
          : (e.message ?? "OTP request failed");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      final res = await api.post(
        ApiEndpoints.verifyEmail,
        data: {"email": email, "otp": otp},
      );
      final data = res.data;
      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "OTP verification failed");
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ??
                "OTP verification failed")
          : (e.message ?? "OTP verification failed");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final res = await api.post(
        ApiEndpoints.resetPassword,
        data: {"email": email, "newPassword": newPassword},
      );
      final data = res.data;
      if (data == null || data["success"] != true) {
        throw Exception(data?["message"] ?? "Reset password failed");
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ?? "Reset password failed")
          : (e.message ?? "Reset password failed");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await api.post(
        ApiEndpoints.changePassword,
        data: {
          // send both keys to match backend expectations
          "currentPassword": currentPassword,
          "oldPassword": currentPassword,
          "newPassword": newPassword,
        },
      );

      final data = res.data;
      final msg = data?["message"]?.toString() ?? "Password changed successfully";
      if (data == null || data["success"] != true) {
        throw Exception(msg.isNotEmpty ? msg : "Change password failed");
      }
      return msg;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ??
                "Change password failed")
          : (e.message ?? "Change password failed");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<SwitchRoleResponseModel> switchRole({String? role}) async {
    try {
      final res = await api.post(
        ApiEndpoints.switchRole,
        data: role == null ? {} : {"role": role},
      );

      final body = res.data as Map<String, dynamic>;
      debugPrint("SWITCH ROLE RAW => $body");

      final parsed = SwitchRoleResponseModel.fromMap(body);

      if (parsed.success != true) {
        throw Exception(
          parsed.message.isNotEmpty ? parsed.message : "Switch role failed",
        );
      }

      // ✅ Save new tokens + role (very important)
      await TokenManager.save(
        access: parsed.data.accessToken,
        refresh: parsed.data.refreshToken,
        uid: parsed.data.user["_id"]?.toString() ?? "",
        userName: parsed.data.user["name"]?.toString() ?? "",
        userEmail: parsed.data.user["email"]?.toString() ?? "",
        userRole: parsed.data.user["role"]?.toString() ?? "",
      );

      return parsed;
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ?? "Switch role error")
          : (e.message ?? "Switch role error");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}

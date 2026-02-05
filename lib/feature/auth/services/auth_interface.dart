import 'package:paschaloliver/feature/auth/models/login_request_model.dart';
import 'package:paschaloliver/feature/auth/models/login_response_model.dart';
import 'package:paschaloliver/feature/auth/models/switch_role_response_model.dart';

abstract class AuthInterface {
  Future<LoginApiResponse> login(LoginRequestModel params);

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role, // "client" or "professional"
  });

  // ✅ forgot password flow
  Future<void> forgotPassword({required String email});
  Future<void> verifyEmail({required String email, required String otp});
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  // ✅ change password
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // ✅ ADD THIS
  Future<SwitchRoleResponseModel> switchRole({String? role});
}

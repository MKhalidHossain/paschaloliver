import 'package:get/get.dart';
import 'package:paschaloliver/feature/auth/services/auth_interface.dart';

class AuthController extends GetxController {
  final AuthInterface authInterface;

  AuthController(this.authInterface);

  final isSwitchingRole = false.obs;
  final isChangingPassword = false.obs;

  Future<String> switchRole({String? role}) async {
    try {
      isSwitchingRole.value = true;

      final res = await authInterface.switchRole(role: role);

      // return new role so UI can navigate
      final newRole = res.data.user["role"]?.toString() ?? "";
      return newRole;
    } finally {
      isSwitchingRole.value = false;
    }
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isChangingPassword.value = true;
      return await authInterface.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }
}

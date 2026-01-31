import 'package:get/get.dart';

class RoleController extends GetxController {
  final RxString selectedRole = ''.obs;

  void setRole(String role) {
    selectedRole.value = role; // "client" or "professional"
  }
}

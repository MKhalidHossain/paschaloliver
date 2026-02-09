import '../models/user_profile_model.dart';

abstract class UserProfileInterface {
  Future<UserProfile> getMe();
  Future<UserProfile> updateMe({
    required String id,
    required String name,
    required String email,
    required String phone,
  });
  Future<void> deactivate();
}

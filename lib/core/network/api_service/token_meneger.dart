import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = "access_token";
  static const _refreshKey = "refresh_key";
  static const _role = "role";

  static Future<void> saveToken(
      {required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  static Future<void> accessToken(String token) async {
    debugPrint("Saving token is $token");
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getEmail() async {
    return _storage.read(key: "email"); // ✅ must be saved at login time
  }

  static Future<void> saveRole(String token) async {
    await _storage.write(key: _role, value: token);
  }

  static Future<void> refreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshKey);
  }

/*
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }*/

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token == null) return false;
    if (token.trim().isEmpty) return false;
    return true;
  }

  //  NEW
  static const _serviceTypeKey = "service_type";

  //  ---------------- SERVICE TYPE ----------------
  static Future<void> saveServiceType(String serviceType) async {
    await _storage.write(key: _serviceTypeKey, value: serviceType);
  }

  static Future<String?> getServiceType() async {
    return await _storage.read(key: _serviceTypeKey);
  }

  static Future<void> clearServiceType() async {
    await _storage.delete(key: _serviceTypeKey);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: _role);
  }

  static Future<void> clearRole() async {
    await _storage.delete(key: _role);
  }
}

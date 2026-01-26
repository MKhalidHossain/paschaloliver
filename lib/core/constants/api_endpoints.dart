import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  static const String socketUrl = _LocalHostWifi.socketUrl;

  static const String baseUrl = _LocalHostWifi.baseUrl;

  // ---------------------- AUTH -----------------------------
  static const String login = _Auth.login;
  static const String register = _Auth.register;
  static const String forgetPassword = _Auth.forgetPassword;
  static const String verifyEmail = _Auth.verifyEmail;
  static const String resetPassword = _Auth.resetPassword;
  static const String logout = _Auth.logout;
  static const String changePassword = _Auth.changePassword;
  static const String switchRole = _Auth.switchRole;
  static const String refreshToken = _Auth.refreshToken;

  // ---------------------- USER -----------------------------
  static const String user = '${baseUrl}/user';

  // ---------------------- Message -----------------------------
}

class _RemoteServer {
  static const String socketUrl = '';

  static const String baseUrl = '';
}

class _LocalHostWifi {
  static const String socketUrl = 'http://10.10.5.98:5000';

  static const String baseUrl = 'http://10.10.5.98:5000/api/v1';
}

class _Auth {
  @protected
  static const String _authRoute = '${ApiEndpoints.baseUrl}/auth';
  // example
  static const String login = '$_authRoute/login';
  static const String register = '$_authRoute/register';
  static const String forgetPassword = '$_authRoute/forget-password';
  static const String verifyEmail = '$_authRoute/verify-email';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String logout = '$_authRoute/logout';
  static const String changePassword = '$_authRoute/change-password';
  static const String switchRole = '$_authRoute/switch-role';
  static const String refreshToken = '$_authRoute/refresh-token';
}

// ---------------------- Notification -----------------------------
class _Notification {
  static const String _notificationRoute =
      '${ApiEndpoints.baseUrl}/notification';
}

class _User {
  static const String _userRoute = '${ApiEndpoints.baseUrl}/user';
}

// ---------------------- MESSAGE -----------------------------
class _Message {
  static const String _messageRoute = '${ApiEndpoints.baseUrl}/message';
}

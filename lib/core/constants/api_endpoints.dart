import 'package:flutter/foundation.dart';

base class ApiEndpoints {
  // static const String socketUrl = _LocalHostWifi.socketUrl;

  // static const String baseUrl = _LocalHostWifi.baseUrl;

  static const String socketUrl = _RemoteServer.socketUrl;

  static const String baseUrl = _RemoteServer.baseUrl;

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
  static const String requestHistory = _Requests.requestHistory;

  // ---------------------- USER -----------------------------
  static const String user = '$baseUrl/user';

  // ---------------------- category -----------------------------
  static const String categories = '$baseUrl/categories';

  //---------------------subcategory-------------------------
  // ✅ subcategory by categoryId
  static String subcategoriesByCategoryId(String categoryId) =>
      '$baseUrl/subcategories/category/$categoryId';
}

class _RemoteServer {
  static const String socketUrl = 'https://api.handynaijaapp.com';

  static const String baseUrl = 'https://api.handynaijaapp.com/api/v1';
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
  static const String forgetPassword = '$_authRoute/forgot-password';
  static const String verifyEmail = '$_authRoute/verify-email';
  static const String resetPassword = '$_authRoute/reset-password';
  static const String logout = '$_authRoute/logout';
  static const String changePassword = '$_authRoute/change-password';
  static const String switchRole = '$_authRoute/switch-role';
  static const String refreshToken = '$_authRoute/refresh-token';
}

class _Requests {
  @protected
  static const String _requestRoute = ApiEndpoints.baseUrl;
  static const String requestHistory = '$_requestRoute/request-history';
}

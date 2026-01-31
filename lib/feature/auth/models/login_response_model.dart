class LoginApiResponse {
  final int statusCode;
  final bool success;
  final String message;
  final LoginData data;

  LoginApiResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginApiResponse.fromMap(Map<String, dynamic> map) {
    return LoginApiResponse(
      statusCode: (map["statusCode"] ?? 0) is int
          ? map["statusCode"] as int
          : int.tryParse(map["statusCode"].toString()) ?? 0,
      success: map["success"] ?? false,
      message: map["message"] ?? "",
      data: LoginData.fromMap(map["data"] ?? const <String, dynamic>{}),
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final LoginUser user;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginData.fromMap(Map<String, dynamic> map) {
    return LoginData(
      accessToken: map["accessToken"] ?? "",
      refreshToken: map["refreshToken"] ?? "",
      user: LoginUser.fromMap(map["user"] ?? const <String, dynamic>{}),
    );
  }
}

class LoginUser {
  final String id; // backend: _id
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool isBlocked;

  LoginUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.isBlocked,
  });

  factory LoginUser.fromMap(Map<String, dynamic> map) {
    return LoginUser(
      id: map["_id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "",
      isActive: map["isActive"] ?? false,
      isBlocked: map["isBlocked"] ?? false,
    );
  }
}

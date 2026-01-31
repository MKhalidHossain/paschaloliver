class SwitchRoleResponseModel {
  final bool success;
  final String message;
  final SwitchRoleData data;

  SwitchRoleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SwitchRoleResponseModel.fromMap(Map<String, dynamic> json) {
    return SwitchRoleResponseModel(
      success: json["success"] == true,
      message: (json["message"] ?? "").toString(),
      data: SwitchRoleData.fromMap(json["data"] ?? {}),
    );
  }
}

class SwitchRoleData {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user; // because API returns user array

  SwitchRoleData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SwitchRoleData.fromMap(Map<String, dynamic> json) {
    final dynamic rawUser = json["user"];
    final Map<String, dynamic> userMap;
    if (rawUser is Map) {
      userMap = Map<String, dynamic>.from(rawUser);
    } else if (rawUser is List && rawUser.isNotEmpty) {
      userMap = Map<String, dynamic>.from(rawUser.first as Map);
    } else {
      userMap = <String, dynamic>{};
    }

    return SwitchRoleData(
      accessToken: (json["accessToken"] ?? "").toString(),
      refreshToken: (json["refreshToken"] ?? "").toString(),
      user: userMap,
    );
  }
}

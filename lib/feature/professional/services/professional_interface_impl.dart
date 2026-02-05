import 'package:dio/dio.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';

import 'professional_interface.dart';

class ProfessionalInterfaceImpl implements ProfessionalInterface {
  final ApiClient apiClient;

  ProfessionalInterfaceImpl({required this.apiClient});

  @override
  Future<void> createProfessionalProfile({required FormData formData}) async {
    try {
      final uid = await TokenManager.getUid();
      final Response res = await apiClient.post(
        ApiEndpoints.professional,
        data: formData,
        options: uid == null || uid.isEmpty
            ? null
            : Options(headers: {"x-user-id": uid}),
      );

      final responseData = res.data;
      if (responseData is Map<String, dynamic>) {
        final success = responseData["success"];
        if (success == false) {
          throw Exception(responseData["message"]?.toString() ??
              "Failed to create professional profile");
        }
      }
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ??
              "Failed to create professional profile")
          : (e.message ?? "Failed to create professional profile");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}

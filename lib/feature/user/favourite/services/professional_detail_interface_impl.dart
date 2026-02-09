import 'package:dio/dio.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';

import '../models/professional_detail_model.dart';
import 'professional_detail_interface.dart';

class ProfessionalDetailInterfaceImpl implements ProfessionalDetailInterface {
  ProfessionalDetailInterfaceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<ProfessionalDetail> getProfessional(String id) async {
    final Response res = await apiClient.get('/professional/$id');
    final body = res.data;
    if (body is Map && body['data'] is Map) {
      final data = Map<String, dynamic>.from(body['data'] as Map);
      return ProfessionalDetailResponse.fromJson(data).professional;
    }
    throw Exception('Invalid professional response');
  }
}

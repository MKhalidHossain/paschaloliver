import 'package:dio/dio.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/requests/models/requests_model.dart';
import 'package:paschaloliver/feature/requests/services/request_history_interface.dart';

class RequestHistoryInterfaceImpl implements RequestHistoryInterface {
  final ApiClient apiClient;

  RequestHistoryInterfaceImpl({required this.apiClient});

  @override
  Future<List<RequestItem>> getRequestHistory() async {
    try {
      final Response res = await apiClient.get(ApiEndpoints.requestHistory);
      final body = res.data;
      final List list = body is Map
          ? (body["data"] as List?) ?? []
          : (body as List?) ?? [];

      return list
          .whereType<Map>()
          .map((e) => RequestItem.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ??
                "Failed to load requests")
          : (e.message ?? "Failed to load requests");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  @override
  Future<RequestItem> getRequestHistoryById(String id) async {
    try {
      final Response res =
          await apiClient.get("${ApiEndpoints.requestHistory}/$id");
      final body = res.data;
      final data = body is Map<String, dynamic> ? body["data"] : body;
      if (data is Map<String, dynamic>) {
        return RequestItem.fromMap(data);
      }
      return RequestItem.fromMap(const <String, dynamic>{});
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data["message"]?.toString() ??
                "Failed to load request")
          : (e.message ?? "Failed to load request");
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }
}

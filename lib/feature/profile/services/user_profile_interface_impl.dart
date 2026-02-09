import 'package:dio/dio.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';

import '../models/user_profile_model.dart';
import 'user_profile_interface.dart';

class UserProfileInterfaceImpl implements UserProfileInterface {
  UserProfileInterfaceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<UserProfile> getMe() async {
    Response res;
    try {
      res = await apiClient.get('/user/me');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        res = await apiClient.get('/users/me');
      } else {
        rethrow;
      }
    }
    final body = res.data;
    if (body is Map && body['data'] is Map) {
      return UserProfile.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
    }
    throw Exception('Invalid user profile response');
  }

  @override
  Future<UserProfile> updateMe({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    final Response res = await apiClient.patch(
      '/users/$id',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    );
    final body = res.data;
    if (body is Map && body['data'] is Map) {
      return UserProfile.fromJson(
        Map<String, dynamic>.from(body['data'] as Map),
      );
    }
    throw Exception('Invalid update response');
  }

  @override
  Future<void> deactivate() async {
    try {
      await apiClient.delete('/user/me');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        await apiClient.delete('/users/me');
      } else {
        rethrow;
      }
    }
  }
}

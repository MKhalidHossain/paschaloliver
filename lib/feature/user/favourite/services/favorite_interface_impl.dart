import 'package:dio/dio.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';

import '../models/favorite_api_models.dart';
import 'favorite_interface.dart';

class FavoriteInterfaceImpl implements FavoriteInterface {
  FavoriteInterfaceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<FavoriteCategoryModel>> getFavorites() async {
    final Response res = await apiClient.get('/favorite');
    final body = res.data;

    final List list = (body is Map && body['data'] is List)
        ? (body['data'] as List)
        : <dynamic>[];
    return list
        .whereType<Map>()
        .map((e) => FavoriteCategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

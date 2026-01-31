import 'package:dio/dio.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/user/home/models/category_model.dart';
import 'package:paschaloliver/feature/user/home/services/category_interface.dart';

class CategoryInterfaceImpl implements CategoryInterface {
  final ApiClient apiClient;

  CategoryInterfaceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    // because ApiClient baseUrl = .../api/v1
    final Response res = await apiClient.get('/categories');

    final body = res.data;
    final List list = (body['data'] as List?) ?? [];

    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }
}

import 'package:paschaloliver/core/network/api_service/api_client.dart';
import '../models/subcategory_model.dart';
import 'subcategory_interface.dart';

class SubCategoryInterfaceImpl implements SubCategoryInterface {
  final ApiClient apiClient;
  SubCategoryInterfaceImpl({required this.apiClient});

  @override
  Future<List<SubCategoryModel>> getByCategoryId(String categoryId) async {
    final res = await apiClient.get('/subcategories/category/$categoryId');
    final List list = (res.data['data'] as List?) ?? [];
    return list.map((e) => SubCategoryModel.fromJson(e)).toList();
  }
}

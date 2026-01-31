import 'package:get/get.dart';
import '../models/subcategory_model.dart';
import '../services/subcategory_interface.dart';

class SubCategoryController extends GetxController {
  final SubCategoryInterface service;
  SubCategoryController({required this.service});

  final isLoading = false.obs;
  final error = ''.obs;
  final items = <SubCategoryModel>[].obs;

  Future<void> fetchByCategoryId(String categoryId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await service.getByCategoryId(categoryId);
      items.assignAll(data.where((e) => e.isActive));
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

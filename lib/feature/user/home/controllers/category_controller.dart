import 'package:get/get.dart';
import 'package:paschaloliver/feature/user/home/models/category_model.dart';
import 'package:paschaloliver/feature/user/home/services/category_interface.dart';

class CategoryController extends GetxController {
  final CategoryInterface service;
  CategoryController({required this.service});

  final isLoading = false.obs;
  final error = ''.obs;
  final categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await service.getAllCategories();

      // ✅ show only active
      categories.assignAll(data.where((e) => e.isActive));
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

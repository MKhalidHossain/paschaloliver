import 'package:get/get.dart';

import '../models/favorite_api_models.dart';
import '../services/favorite_interface.dart';

class FavoriteController extends GetxController {
  FavoriteController({required this.service});

  final FavoriteInterface service;

  final isLoading = false.obs;
  final error = ''.obs;
  final items = <FavoriteCategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await service.getFavorites();
      items.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

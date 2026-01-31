import '../models/subcategory_model.dart';

abstract class SubCategoryInterface {
  Future<List<SubCategoryModel>> getByCategoryId(String categoryId);
}

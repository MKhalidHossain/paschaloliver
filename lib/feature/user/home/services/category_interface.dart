import 'package:paschaloliver/feature/user/home/models/category_model.dart';

abstract class CategoryInterface {
  Future<List<CategoryModel>> getAllCategories();
}

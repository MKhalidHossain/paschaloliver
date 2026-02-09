import '../models/favorite_api_models.dart';

abstract class FavoriteInterface {
  Future<List<FavoriteCategoryModel>> getFavorites();
}

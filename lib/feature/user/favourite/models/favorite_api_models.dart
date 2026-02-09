class FavoriteCategoryModel {
  FavoriteCategoryModel({
    required this.subcategory,
    required this.image,
    required this.count,
    required this.professionals,
  });

  final String subcategory;
  final String image;
  final int count;
  final List<FavoriteProfessional> professionals;

  factory FavoriteCategoryModel.fromJson(Map<String, dynamic> json) {
    final List pros = (json['professionals'] as List?) ?? [];
    return FavoriteCategoryModel(
      subcategory: (json['subcategory'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      count: (json['count'] is num)
          ? (json['count'] as num).toInt()
          : int.tryParse("${json['count']}") ?? 0,
      professionals: pros
          .whereType<Map>()
          .map((e) => FavoriteProfessional.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class FavoriteProfessional {
  FavoriteProfessional({
    required this.id,
    required this.name,
    required this.gallery,
    required this.price,
    required this.rating,
    required this.reviewCount,
  });

  final String id;
  final String name;
  final List<String> gallery;
  final double price;
  final double rating;
  final int reviewCount;

  factory FavoriteProfessional.fromJson(Map<String, dynamic> json) {
    final List g = (json['gallery'] as List?) ?? [];
    return FavoriteProfessional(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      gallery: g.map((e) => e.toString()).toList(),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse("${json['price']}") ?? 0,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse("${json['rating']}") ?? 0,
      reviewCount: (json['reviewCount'] is num)
          ? (json['reviewCount'] as num).toInt()
          : int.tryParse("${json['reviewCount']}") ?? 0,
    );
  }
}

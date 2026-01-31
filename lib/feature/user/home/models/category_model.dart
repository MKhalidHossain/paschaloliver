class CategoryModel {
  final String id;
  final String title;
  final String image;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      isActive: json['isActive'] == true,
    );
  }
}

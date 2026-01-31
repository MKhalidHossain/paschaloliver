class SubCategoryModel {
  final String id;
  final String title;
  final String image;
  final bool isActive;

  SubCategoryModel({
    required this.id,
    required this.title,
    required this.image,
    required this.isActive,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: (json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      isActive: json['isActive'] == true,
    );
  }
}

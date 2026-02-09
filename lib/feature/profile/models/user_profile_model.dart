class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.about,
    required this.image,
    required this.phone,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String about;
  final String image;
  final String phone;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      isActive: json['isActive'] == true,
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      about: (json['about'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }
}

class ProfessionalDetailResponse {
  ProfessionalDetailResponse({required this.professional});

  final ProfessionalDetail professional;

  factory ProfessionalDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProfessionalDetailResponse(
      professional: ProfessionalDetail.fromJson(
        Map<String, dynamic>.from(json['professional'] as Map),
      ),
    );
  }
}

class ProfessionalDetail {
  ProfessionalDetail({
    required this.id,
    required this.user,
    required this.profileDetails,
    required this.gallery,
    required this.comments,
  });

  final String id;
  final ProfessionalUser user;
  final ProfessionalProfileDetails profileDetails;
  final List<String> gallery;
  final List<dynamic> comments;

  factory ProfessionalDetail.fromJson(Map<String, dynamic> json) {
    final List g = (json['gallery'] as List?) ?? [];
    final List c = (json['comments'] as List?) ?? [];
    return ProfessionalDetail(
      id: (json['_id'] ?? '').toString(),
      user: ProfessionalUser.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      profileDetails: ProfessionalProfileDetails.fromJson(
        Map<String, dynamic>.from(json['profileDetails'] as Map),
      ),
      gallery: g.map((e) => e.toString()).toList(),
      comments: c,
    );
  }
}

class ProfessionalUser {
  ProfessionalUser({
    required this.id,
    required this.name,
    required this.about,
  });

  final String id;
  final String name;
  final String about;

  factory ProfessionalUser.fromJson(Map<String, dynamic> json) {
    return ProfessionalUser(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      about: (json['about'] ?? '').toString(),
    );
  }
}

class ProfessionalProfileDetails {
  ProfessionalProfileDetails({
    required this.experienceLevel,
    required this.hasIndustryExperience,
    required this.employmentStatus,
    required this.currentSituation,
  });

  final String experienceLevel;
  final bool hasIndustryExperience;
  final String employmentStatus;
  final String currentSituation;

  factory ProfessionalProfileDetails.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileDetails(
      experienceLevel: (json['experienceLevel'] ?? '').toString(),
      hasIndustryExperience: json['hasIndustryExperience'] == true,
      employmentStatus: (json['employmentStatus'] ?? '').toString(),
      currentSituation: (json['currentSituation'] ?? '').toString(),
    );
  }
}

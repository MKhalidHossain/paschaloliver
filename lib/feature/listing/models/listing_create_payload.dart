class ListingCreatePayload {
  ListingCreatePayload({
    required this.subcategoryIds,
    required this.price,
    required this.profileDetails,
    required this.about,
    this.discountPercent,
  });

  final List<String> subcategoryIds;
  final double price;
  final ProfileDetails profileDetails;
  final String about;
  final double? discountPercent;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'subcategories': subcategoryIds,
      'price': price,
      'profileDetails': profileDetails.toJson(),
      'about': about,
    };

    if (discountPercent != null) {
      data['discountPercent'] = discountPercent;
    }

    return data;
  }
}

class ProfileDetails {
  ProfileDetails({
    required this.experienceLevel,
    required this.hasIndustryExperience,
    required this.employmentStatus,
    required this.currentSituation,
  });

  final String experienceLevel;
  final bool hasIndustryExperience;
  final String employmentStatus;
  final String currentSituation;

  Map<String, dynamic> toJson() => {
    'experienceLevel': experienceLevel,
    'hasIndustryExperience': hasIndustryExperience,
    'employmentStatus': employmentStatus,
    'currentSituation': currentSituation,
  };
}

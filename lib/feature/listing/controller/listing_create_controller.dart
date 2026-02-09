import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/listing_create_payload.dart';
import '../services/listing_interface.dart';

class ListingCreateController extends GetxController {
  ListingCreateController({required this.service});

  final ListingInterface service;

  final subcategoryIds = <String>[].obs;
  final price = 0.0.obs;
  final discountPercent = RxnDouble();

  final experienceLevel = ''.obs;
  final hasIndustryExperience = RxnBool();
  final employmentStatus = ''.obs;
  final currentSituation = ''.obs;

  final about = ''.obs;
  final gallery = <File>[].obs;

  final isSubmitting = false.obs;
  final isChecking = false.obs;
  final error = ''.obs;
  final hasListing = false.obs;

  void setSubcategory(String id) {
    subcategoryIds.assignAll([id]);
  }

  void setPrice(double value) {
    price.value = value;
  }

  void setDiscountPercent(double? value) {
    discountPercent.value = value;
  }

  void setProfileDetails({
    required String experience,
    required bool hasIndustryExp,
    required String employment,
    required String situation,
  }) {
    experienceLevel.value = experience;
    hasIndustryExperience.value = hasIndustryExp;
    employmentStatus.value = employment;
    currentSituation.value = situation;
  }

  void setAbout(String text) {
    about.value = text;
  }

  void setGallery(List<File> files) {
    gallery.assignAll(files);
  }

  String? validateForSubmit() {
    if (subcategoryIds.isEmpty) return 'Please select a subcategory.';
    if (price.value <= 0) return 'Please enter a valid price.';
    if (gallery.length > 5) return 'Please upload up to 5 images only.';
    if (experienceLevel.value.isEmpty) {
      return 'Please select your experience level.';
    }
    if (hasIndustryExperience.value == null) {
      return 'Please choose your industry experience.';
    }
    if (employmentStatus.value.isEmpty) {
      return 'Please select your employment status.';
    }
    if (currentSituation.value.isEmpty) {
      return 'Please select your current situation.';
    }
    if (about.value.trim().length < 50) {
      return 'About me must be at least 50 characters.';
    }
    if (gallery.isEmpty) {
      return 'Please add at least one gallery image.';
    }
    return null;
  }

  Future<bool> submit() async {
    final validation = validateForSubmit();
    if (validation != null) {
      error.value = validation;
      return false;
    }

    isSubmitting.value = true;
    error.value = '';

    try {
      final payload = ListingCreatePayload(
        subcategoryIds: subcategoryIds.toList(),
        price: price.value,
        discountPercent: discountPercent.value,
        profileDetails: ProfileDetails(
          experienceLevel: experienceLevel.value,
          hasIndustryExperience: hasIndustryExperience.value ?? false,
          employmentStatus: employmentStatus.value,
          currentSituation: currentSituation.value,
        ),
        about: about.value.trim(),
      );

      await service.createListing(payload, gallery.toList());
      hasListing.value = true;
      return true;
    } on DioException catch (e) {
      String msg = 'Failed to submit listing';
      final data = e.response?.data;
      if (data is Map) {
        final m = data['message'];
        if (m is String && m.trim().isNotEmpty) {
          msg = m.trim();
        } else if (data['errorSources'] is List &&
            data['errorSources'].isNotEmpty) {
          final first = data['errorSources'][0];
          if (first is Map && first['message'] is String) {
            msg = (first['message'] as String).trim();
          }
        }
      } else if (data is String && data.trim().isNotEmpty) {
        // HTML/plain error bodies (e.g., 413)
        if (e.response?.statusCode == 413) {
          msg = 'Images too large. Please upload smaller images.';
        } else {
          msg = data.trim();
        }
      } else if (e.response?.statusCode != null) {
        msg = 'Request failed (${e.response!.statusCode})';
      }
      error.value = msg;
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> fetchHasListing() async {
    isChecking.value = true;
    try {
      hasListing.value = await service.hasListing();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isChecking.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHasListing();
  }
}

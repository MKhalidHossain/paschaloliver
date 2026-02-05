import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class ProfessionalRegistrationController extends GetxController {
  // Location / working areas
  String? country;
  String? city;
  List<String> workingAreas = [];

  // Personal details
  String? name;
  String? surname;
  String? gender;
  DateTime? dateOfBirth;
  String? countryOfBirth;
  String? cityOfBirth;

  // Identity
  String? documentType; // government_id | passport
  String? documentNumber;
  String? documentCountry;
  File? documentFrontImage;
  File? documentBackImage;

  // Address
  String? street;
  String? streetNumber;
  String? zipCode;
  String? addressCity;
  String? addressCountry;
  String? region;

  // Work schedule (pre-serialized)
  List<Map<String, dynamic>> workSchedule = [];

  void setCountry(String value) => country = value;
  void setCity(String value) => city = value;
  void setWorkingAreas(List<String> areas) => workingAreas = areas;

  void setPersonalDetails({
    required String name,
    required String surname,
    required String gender,
    required DateTime dateOfBirth,
    required String countryOfBirth,
    required String cityOfBirth,
  }) {
    this.name = name;
    this.surname = surname;
    this.gender = gender;
    this.dateOfBirth = dateOfBirth;
    this.countryOfBirth = countryOfBirth;
    this.cityOfBirth = cityOfBirth;
  }

  void setIdentity({
    required String documentType,
    required String documentNumber,
    required String documentCountry,
  }) {
    this.documentType = documentType;
    this.documentNumber = documentNumber;
    this.documentCountry = documentCountry;
  }

  void setAddress({
    required String street,
    required String streetNumber,
    required String zipCode,
    required String addressCity,
    required String addressCountry,
    required String region,
  }) {
    this.street = street;
    this.streetNumber = streetNumber;
    this.zipCode = zipCode;
    this.addressCity = addressCity;
    this.addressCountry = addressCountry;
    this.region = region;
  }

  void setWorkSchedule(List<Map<String, dynamic>> schedule) {
    workSchedule = schedule;
  }

  String _documentTypeLabel() {
    if (documentType == null) return '';
    if (documentType == 'government_id') return 'Government ID';
    if (documentType == 'passport') return 'Passport';
    return documentType!;
  }

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'personalDetails[name]': name,
      'personalDetails[surname]': surname,
      'personalDetails[gender]': gender,
      'personalDetails[dateOfBirth]':
          dateOfBirth == null ? null : dateOfBirth!.toIso8601String().split('T').first,
      'personalDetails[countryOfBirth]': countryOfBirth,
      'personalDetails[cityOfBirth]': cityOfBirth,
      'identity[documentType]': _documentTypeLabel(),
      'identity[documentNumber]': documentNumber,
      'identity[documentCountry]': documentCountry,
      'address[street]': street,
      'address[streetNumber]': streetNumber,
      'address[zipCode]': zipCode,
      'address[city]': addressCity,
      'address[country]': addressCountry,
      'address[region]': region,
      'country': country,
      'city': city,
      'workingAreas': workingAreas,
      'workSchedule': jsonEncode(workSchedule),
      'profileDetails': jsonEncode({
        'cleaningTypes': <String>[],
        'additionalTasks': <String>[],
      }),
    };

    map.removeWhere((_, v) {
      if (v == null) return true;
      if (v is String && v.trim().isEmpty) return true;
      if (v is List && v.isEmpty) return true;
      return false;
    });

    if (documentFrontImage != null) {
      map['documentFrontImage'] = await MultipartFile.fromFile(
        documentFrontImage!.path,
        filename: documentFrontImage!.path.split('/').last,
      );
    }
    if (documentBackImage != null) {
      map['documentBackImage'] = await MultipartFile.fromFile(
        documentBackImage!.path,
        filename: documentBackImage!.path.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}

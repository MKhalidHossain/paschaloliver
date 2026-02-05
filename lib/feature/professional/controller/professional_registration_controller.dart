import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:paschaloliver/core/network/api_service/token_meneger.dart';

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
    final form = FormData();

    void addField(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      form.fields.add(MapEntry(key, value.toString()));
    }

    final uid = await TokenManager.getUid();
    final uidFromToken = uid ?? await TokenManager.getUidFromToken();
    addField('user', uidFromToken);
    // Extra fallbacks for backend parsers that expect different keys.
    addField('userId', uidFromToken);
    addField('user_id', uidFromToken);

    addField('personalDetails[name]', name);
    addField('personalDetails[surname]', surname);
    addField('personalDetails[gender]', gender);
    addField(
      'personalDetails[dateOfBirth]',
      dateOfBirth == null
          ? null
          : dateOfBirth!.toIso8601String().split('T').first,
    );
    addField('personalDetails[countryOfBirth]', countryOfBirth);
    addField('personalDetails[cityOfBirth]', cityOfBirth);

    addField('identity[documentType]', _documentTypeLabel());
    addField('identity[documentNumber]', documentNumber);
    addField('identity[documentCountry]', documentCountry);

    addField('address[street]', street);
    addField('address[streetNumber]', streetNumber);
    addField('address[zipCode]', zipCode);
    addField('address[city]', addressCity);
    addField('address[country]', addressCountry);
    addField('address[region]', region);

    addField('country', country);
    addField('city', city);

    if (workingAreas.isNotEmpty) {
      for (var i = 0; i < workingAreas.length; i++) {
        addField('workingAreas[$i]', workingAreas[i]);
      }
    }

    if (workSchedule.isNotEmpty) {
      for (var i = 0; i < workSchedule.length; i++) {
        final item = workSchedule[i];
        final day = item['day'];
        final isAvailable = item['isAvailable'];
        addField('workSchedule[$i][day]', day);
        if (isAvailable != null) {
          addField('workSchedule[$i][isAvailable]', isAvailable.toString());
        }

        final slots = item['slots'];
        if (slots is List) {
          for (var j = 0; j < slots.length; j++) {
            final slot = slots[j];
            if (slot is Map) {
              addField(
                'workSchedule[$i][slots][$j][startTime]',
                slot['startTime'],
              );
              addField(
                'workSchedule[$i][slots][$j][endTime]',
                slot['endTime'],
              );
            }
          }
        }
      }
    }

    // Only send profileDetails if user actually selected anything.
    // This avoids backend "expected object, received string" errors.
    final cleaningTypes = <String>[];
    final additionalTasks = <String>[];
    if (cleaningTypes.isNotEmpty) {
      for (var i = 0; i < cleaningTypes.length; i++) {
        addField('profileDetails[cleaningTypes][$i]', cleaningTypes[i]);
      }
    }
    if (additionalTasks.isNotEmpty) {
      for (var i = 0; i < additionalTasks.length; i++) {
        addField('profileDetails[additionalTasks][$i]', additionalTasks[i]);
      }
    }

    if (documentFrontImage != null) {
      form.files.add(
        MapEntry(
          'documentFrontImage',
          await MultipartFile.fromFile(
            documentFrontImage!.path,
            filename: documentFrontImage!.path.split('/').last,
          ),
        ),
      );
    }
    if (documentBackImage != null) {
      form.files.add(
        MapEntry(
          'documentBackImage',
          await MultipartFile.fromFile(
            documentBackImage!.path,
            filename: documentBackImage!.path.split('/').last,
          ),
        ),
      );
    }

    return form;
  }
}

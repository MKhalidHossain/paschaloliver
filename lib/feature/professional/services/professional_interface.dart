import 'package:dio/dio.dart';

abstract class ProfessionalInterface {
  Future<void> createProfessionalProfile({required FormData formData});
}

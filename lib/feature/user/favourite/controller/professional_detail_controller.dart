import 'package:get/get.dart';

import '../models/professional_detail_model.dart';
import '../services/professional_detail_interface.dart';

class ProfessionalDetailController extends GetxController {
  ProfessionalDetailController({required this.service});

  final ProfessionalDetailInterface service;

  final isLoading = false.obs;
  final error = ''.obs;
  final detail = Rxn<ProfessionalDetail>();

  Future<void> fetch(String id) async {
    try {
      isLoading.value = true;
      error.value = '';
      detail.value = await service.getProfessional(id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

import '../models/professional_detail_model.dart';

abstract class ProfessionalDetailInterface {
  Future<ProfessionalDetail> getProfessional(String id);
}

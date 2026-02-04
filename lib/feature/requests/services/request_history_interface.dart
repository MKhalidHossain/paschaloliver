import 'package:paschaloliver/feature/requests/models/requests_model.dart';

abstract class RequestHistoryInterface {
  Future<List<RequestItem>> getRequestHistory();
  Future<RequestItem> getRequestHistoryById(String id);
}

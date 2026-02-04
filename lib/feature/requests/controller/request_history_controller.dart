import 'package:get/get.dart';
import 'package:paschaloliver/feature/requests/models/requests_model.dart';
import 'package:paschaloliver/feature/requests/services/request_history_interface.dart';

class RequestHistoryController extends GetxController {
  final RequestHistoryInterface service;
  RequestHistoryController({required this.service});

  final isLoading = false.obs;
  final error = ''.obs;
  final items = <RequestItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      error.value = '';
      final data = await service.getRequestHistory();
      items.assignAll(data);
    } catch (e) {
      error.value = e.toString().replaceFirst("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }

  List<RequestItem> filterByStatus(String status) {
    final s = status.toLowerCase();
    if (s == "completed") {
      return items.where((e) => _isCompleted(e.status)).toList();
    }
    if (s == "canceled") {
      return items.where((e) => _isCanceled(e.status)).toList();
    }
    return items.where((e) => _isNew(e.status)).toList();
  }

  bool _isCompleted(String status) {
    final s = status.toLowerCase();
    return s == "completed" ||
        s == "done" ||
        s == "finished" ||
        s == "success";
  }

  bool _isCanceled(String status) {
    final s = status.toLowerCase();
    return s == "canceled" ||
        s == "cancelled" ||
        s == "rejected" ||
        s == "declined";
  }

  bool _isNew(String status) {
    if (status.trim().isEmpty) return true;
    final s = status.toLowerCase();
    return s == "pending" || s == "new" || s == "requested";
  }
}

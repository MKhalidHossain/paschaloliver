import 'package:get/get.dart';
import 'package:paschaloliver/core/constants/api_endpoints.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';
import 'package:paschaloliver/feature/auth/controller/auth_controller.dart';
import 'package:paschaloliver/feature/auth/services/auth_interface.dart';
import 'package:paschaloliver/feature/auth/services/auth_interface_impl.dart';
import 'package:paschaloliver/core/language/language_controller.dart';
import 'package:paschaloliver/feature/professional/controller/professional_registration_controller.dart';
import 'package:paschaloliver/feature/professional/services/professional_interface.dart';
import 'package:paschaloliver/feature/professional/services/professional_interface_impl.dart';
import 'package:paschaloliver/feature/requests/controller/request_history_controller.dart';
import 'package:paschaloliver/feature/requests/services/request_history_interface.dart';
import 'package:paschaloliver/feature/requests/services/request_history_interface_impl.dart';
import 'package:paschaloliver/feature/user/home/controllers/category_controller.dart';
import 'package:paschaloliver/feature/user/home/controllers/subcategory_controller.dart';
import 'package:paschaloliver/feature/user/home/services/category_interface.dart';
import 'package:paschaloliver/feature/user/home/services/category_interface_impl.dart';
import 'package:paschaloliver/feature/user/home/services/subcategory_interface.dart';
import 'package:paschaloliver/feature/user/home/services/subcategory_interface_impl.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Core Api Client
    Get.lazyPut<ApiClient>(() => ApiClient(ApiEndpoints.baseUrl), fenix: true);

    // ✅ Category Interface -> Impl
    Get.lazyPut<CategoryInterface>(
      () => CategoryInterfaceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // ✅ Category Controller
    Get.lazyPut<CategoryController>(
      () => CategoryController(service: Get.find<CategoryInterface>()),
      fenix: true,
    );

    // Subcategory interface
    Get.lazyPut<SubCategoryInterface>(
      () => SubCategoryInterfaceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Subcategory controller
    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(service: Get.find<SubCategoryInterface>()),
      fenix: true,
    );

    final apiClient = ApiClient(ApiEndpoints.baseUrl);

    Get.lazyPut<AuthInterface>(() => AuthInterfaceImpl(apiClient), fenix: true);
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<AuthInterface>()),
      fenix: true,
    );

    // ✅ Language controller (singleton)
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);

    // ✅ Professional registration data
    Get.lazyPut<ProfessionalRegistrationController>(
      () => ProfessionalRegistrationController(),
      fenix: true,
    );

    // ✅ Professional API
    Get.lazyPut<ProfessionalInterface>(
      () => ProfessionalInterfaceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // ✅ Requests history (professional)
    Get.lazyPut<RequestHistoryInterface>(
      () => RequestHistoryInterfaceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<RequestHistoryController>(
      () => RequestHistoryController(
        service: Get.find<RequestHistoryInterface>(),
      ),
      fenix: true,
    );
  }
}

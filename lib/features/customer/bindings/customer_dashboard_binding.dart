import 'package:get/get.dart';
import 'package:apptravel/features/customer/controllers/customer_dashboard_controller.dart';

class CustomerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDashboardController>(() => CustomerDashboardController());
  }
}

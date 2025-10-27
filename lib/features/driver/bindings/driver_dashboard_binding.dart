import 'package:get/get.dart';
import 'package:apptravel/features/driver/controllers/driver_dashboard_controller.dart';

class DriverDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverDashboardController>(() => DriverDashboardController());
  }
}

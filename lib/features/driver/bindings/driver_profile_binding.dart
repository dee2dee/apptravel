import 'package:get/get.dart';
import 'package:apptravel/features/driver/controllers/driver_profile_controller.dart';

class DriverProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverProfileController());
  }
}

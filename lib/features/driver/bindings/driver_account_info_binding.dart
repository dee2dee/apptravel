import 'package:get/get.dart';
import 'package:apptravel/features/driver/controllers/driver_account_info_controller.dart';

class DriverAccountInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverAccountInfoController());
  }
}

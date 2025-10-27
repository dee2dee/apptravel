import 'package:get/get.dart';
import 'package:apptravel/features/customer/controllers/customer_profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

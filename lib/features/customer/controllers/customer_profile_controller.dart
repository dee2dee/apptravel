import 'package:get/get.dart';
import 'package:apptravel/core/services/api_service.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading(true);
      final response = await ApiService.getUser();
      if (response != null && response['full_name'] != null) {
        userName.value = response['full_name'];
      }
    } finally {
      isLoading(false);
    }
  }
}

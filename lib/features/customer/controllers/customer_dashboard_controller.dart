import 'package:get/get.dart';
import 'package:apptravel/core/services/api_service.dart';
import 'package:apptravel/features/customer/pages/customer_profile.dart';

class CustomerDashboardController extends GetxController {
  /// State untuk bottom navigation
  var selectedIndex = 0.obs;

  /// State untuk loading shimmer
  var isLoading = true.obs;

  /// State untuk nama user
  var fullName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  /// Handle ketika menu bottom navigation di-tap
  void onItemTapped(int index) async {
    selectedIndex.value = index;
    // contoh: bisa ditambah navigasi berdasarkan index
    //if (index == 3) { Get.toNamed(AppRoutes.profile); }
    if (index == 3) {
      final result = await Get.to(const ProfileScreen());
      if (result != null && result is int) {
        selectedIndex.value = result;
      }
    }
  }

  /// Fetch data user dari API /users
  Future<void> fetchUser() async {
    try {
      isLoading.value = true;

      final data = await ApiService.getUser();

      if (data != null) {
        fullName.value = data['full_name'] ?? '';
      } else {
        Get.snackbar("Error", "Gagal ambil data user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

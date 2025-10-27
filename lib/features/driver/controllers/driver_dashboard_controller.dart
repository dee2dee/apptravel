import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptravel/core/services/api_service.dart';
import 'package:apptravel/features/driver/pages/driver_profile.dart';

class DriverDashboardController extends GetxController {
  /// State untuk bottom navigation
  var selectedIndex = 0.obs;

  /// pendapatan (misal default Rp 1.500.000)
  var pendapatan = 1500000.0.obs;

  /// kontrol visibilitas pendapatan
  var isVisible = true.obs;

  /// State untuk nama user
  var fullName = 'Loading...'.obs;

  var email = "".obs;
  var phone = "".obs;

  /// State untuk loading shimmer
  var isLoadingX = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  /// format angka ke mata uang (IDR)
  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// toggle show/hide pendapatan
  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  /// Handle ketika menu bottom navigation di-tap
  void onItemTapped(int index) async {
    selectedIndex.value = index;
    // contoh: bisa ditambah navigasi berdasarkan index
    //if (index == 3) { Get.toNamed(AppRoutes.profile); }
    if (index == 3) {
      final result = await Get.to(const DriverProfileScreen());
      if (result != null && result is int) {
        selectedIndex.value = result;
      }
    }
  }

  /// Fetch data user dari API /users
  Future<void> fetchUser() async {
    try {
      // isLoadingX.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final data = await ApiService.getUser();

      if (data != null) {
        fullName.value = data['full_name'] ?? '';
        email.value = data['email'] ?? '';
        phone.value = data['phone'] ?? '';
        
      } else {
        Get.snackbar("Error", "Gagal ambil data user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingX.value = false;
    }
  }
  
}

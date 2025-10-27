import 'package:apptravel/core/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:apptravel/core/services/api_service.dart';

class OtpController extends GetxController {
  var phoneNumber = ''.obs;
  var userId = 0.obs;
  var deviceRef = ''.obs;
  var expiredAt = ''.obs;
  var otp = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Ambil semua data dari arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    phoneNumber.value = args["phone"] ?? "";
    //userId.value = int.tryParse(args["userId"]?.toString() ?? '0') ?? 0;
    userId.value = args["userId"] ?? "";
    deviceRef.value = args["deviceRef"] ?? "";
    expiredAt.value = args["expiredAt"] ?? "";

    print("OTP Controller Init: userId=${userId.value}, deviceRef=${deviceRef.value}");
  }

  /// Update input OTP
  void updateOtp(String value) {
    otp.value = value;
  }

  /// Verifikasi OTP
  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      Get.snackbar("Error", "Kode OTP harus 6 digit");
      return;
    }

    isLoading.value = true;
    try {
      final response = await ApiService.verifyOTP(
        userId.value,
        otp.value,
        deviceRef.value,
      );

      if (response['token'] != null) {
        final role = response['role'];
        final status = response['status'];

        print("Role dari backend: $role, Status: $status ✅");
        print("OTP Verified ✅");
        Get.snackbar("Sukses", "OTP berhasil diverifikasi");

        // contoh: pindah ke dashboard
        if (role == "customer") {
          Get.offAllNamed(AppRoutes.customerDashboard);
        } else if (role == "driver") {
          if (status == "pending") {
            Get.offAllNamed(AppRoutes.driverDashboard);
          } else if (status == "active") {
            Get.snackbar("Info", "Akun Anda berstatus: $status");
          }
        }
      } else {
        Get.snackbar("Error", response['message'] ?? "Verifikasi OTP gagal");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Kirim ulang OTP
  Future<void> resendOtp() async {
    try {
      final response = await ApiService.generateOTP(phoneNumber.value, deviceRef.value);

      if (response['success'] == true) {
        Get.snackbar("Info", "OTP baru telah dikirim");
      } else {
        Get.snackbar("Error", response['message'] ?? "Gagal mengirim ulang OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

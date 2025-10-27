import 'package:apptravel/core/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:apptravel/core/services/api_service.dart';
import 'package:apptravel/core/utils/device_utils.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();

  var isValid = false.obs;
  var isLoading = false.obs;

  void updatePhone(String value) {
    // Hapus angka 0 di depan
    if (value.startsWith("0")) {
      phoneController.text = value.replaceFirst(RegExp(r'^0+'), '');
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length),
      );
    }

    // Validasi panjang minimal
    isValid.value = phoneController.text.length >= 9;
  }

  Future<void> sendOTP() async {
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Nomor WhatsApp wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      String phone = phoneController.text.trim();
      if (phone.startsWith('0')) {
        phone = phone.replaceFirst(RegExp(r'^0+'), '');
      }

      // Ambil device info
      final device = await DeviceUtils.getDeviceInfo();
      final formattedPhone = "+62$phone";
      final deviceRef = device.deviceId; // device_id untuk backend

      //print("Kirim OTP ke: $formattedPhone dengan deviceRef: $deviceRef");

      // Panggil API generateOTP
      final response = await ApiService.generateOTP(
        formattedPhone, deviceRef,
        );

      print("Response API generateOTP: $response");

      if (response['message'] == "OTP generated successfully") {
        final userId = response['user_id'] ?? 0;
        final deviceRef = response['device_ref'] ?? device.deviceId;

        // OTP berhasil dikirim → navigasi ke halaman verifikasi
        Get.toNamed(
          AppRoutes.otpVerification,
          arguments: {
            'phone': formattedPhone,
            'userId': userId,
            'deviceRef': deviceRef,
            'expiredAt': response['expired_at'] ?? '',
          },
        );
      } else {
        // Gagal mengirim OTP → tampilkan pesan error
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal mengirim OTP',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error saat memanggil API: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }  
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptravel/core/routes/app_routes.dart';
import 'package:apptravel/core/services/api_service.dart';
import 'package:apptravel/core/utils/device_utils.dart';
import 'package:apptravel/features/customer/models/model.dart';

class RegisterController extends GetxController {
  // Controllers untuk TextFormField
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  final selectedGender = RxnString();
  final isLoading = false.obs;
  final isFormLoading = true.obs;
  final obscurePassword = true.obs;
  final selectedRole = "customer".obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Simulasi shimmer selama 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      isFormLoading.value = false;
    });
  }

  // Fungsi register
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Format nomor WA
      String phone = phoneController.text.trim();
      if (phone.startsWith('0')) {
        phone = phone.replaceFirst(RegExp(r'^0+'), '');
      }
      phone = "+62$phone";

      // Ambil device info
      final device = await DeviceUtils.getDeviceInfo();

      final user = User(
        fullName: fullNameController.text.trim(),
        gender: selectedGender.value ?? "",
        phone: phone,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: selectedRole.value,
        device: device,
      );

      final response = await Future.wait([
      ApiService.registerUser(user),
      Future.delayed(const Duration(seconds: 2)), // simulasi loading
    ]).then((results) => results[0]);

    if (response["status"] == true) {
      showModalBottomSheet(
        context: Get.context!,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Registrasi Berhasil!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Akun kamu sudah berhasil dibuat.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34495E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // tutup modal dulu
                        Get.offAllNamed(AppRoutes.portal);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } 
    } catch (e) {
      showModalBottomSheet(
        context: Get.context!,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_rounded, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Registrasi Gagal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan coba lagi.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34495E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // tutup modal dulu
                        Get.offAllNamed(AppRoutes.portal);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      isLoading.value = false;
    }

  }
}

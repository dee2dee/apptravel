import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:apptravel/core/services/api_service.dart';

class DriverAccountInfoController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final whatsappController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void saveAccountInfo() {
    // TODO: simpan data ke backend
    Get.snackbar(
      "Berhasil",
      "Informasi akun berhasil diperbarui",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  /// Fetch data user dari API /users
  Future<void> fetchUser() async {
    try {
      final data = await ApiService.getUser();
      print("User Data: $data");

      if (data != null) {
        nameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        whatsappController.text = data['phone'] ?? '';
      } else {
        Get.snackbar("Error", "Gagal ambil data user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}

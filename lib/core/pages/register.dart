import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apptravel/core/controllers/register_controller.dart';
import 'package:apptravel/core/utils/validators.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find<RegisterController>();

    InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: suffixIcon,
        helperText: ' ',
        errorStyle: const TextStyle(height: 0.8),
      );
    }

    Widget _buildShimmerForm() {
      return ListView(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 200, color: Colors.white),
                const SizedBox(height: 30),
                ...List.generate(
                  5,
                  (index) => Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                Container(height: 16, width: 160, color: Colors.white),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Buat Akun Baru",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isFormLoading.value) return _buildShimmerForm();

          return Form(
            key: controller.formKey,
            child: ListView(
              children: [
                const Text(
                  "Silakan masukan data yang valid.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                // Tambahkan di dalam ListView (sebelum TextFormField Nama Lengkap)

                const SizedBox(height: 10),

                Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          "Customer",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        value: "customer",
                        groupValue: controller.selectedRole.value,
                        onChanged: (value) {
                          if (value != null) controller.selectedRole.value = value;
                        },
                        activeColor: const Color(0xFF34495E),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          "Driver",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        value: "driver",
                        groupValue: controller.selectedRole.value,
                        onChanged: (value) {
                          if (value != null) controller.selectedRole.value = value;
                        },
                        activeColor: const Color(0xFF34495E),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 16),
                
                // Full Name
                TextFormField(
                  controller: controller.fullNameController,
                  decoration: _inputDecoration("Nama Lengkap"),
                  validator: Validators.validateFullName,
                  inputFormatters: Validators.inputFormattersFullName,
                ),
                const SizedBox(height: 10),

                // Gender
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedGender.value,
                      decoration: _inputDecoration("Jenis Kelamin"),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: const [
                        DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
                      ],
                      onChanged: (value) => controller.selectedGender.value = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Pilih jenis kelamin" : null,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                      borderRadius: BorderRadius.circular(12),
                      menuMaxHeight: 200,
                    )),
                const SizedBox(height: 10),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: _inputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  inputFormatters: Validators.inputFormattersEmail,
                ),
                const SizedBox(height: 10),

                // Phone
                TextFormField(
                  controller: controller.phoneController,
                  decoration: _inputDecoration("Nomor WhatsApp"),
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                  inputFormatters: Validators.inputFormattersPhone,
                  onChanged: (value) {
                    if (value.startsWith('0')) {
                      controller.phoneController.text =
                          value.replaceFirst(RegExp(r'^0+'), '');
                      controller.phoneController.selection =
                          TextSelection.fromPosition(
                              TextPosition(offset: controller.phoneController.text.length));
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Password
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      decoration: _inputDecoration(
                        "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              controller.obscurePassword.value = !controller.obscurePassword.value,
                        ),
                      ),
                      obscureText: controller.obscurePassword.value,
                      validator: Validators.validatePassword,
                      inputFormatters: Validators.inputFormattersPassword,
                    )),
                const SizedBox(height: 10),

                // Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34495E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "BUAT AKUN",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        "MASUK SEKARANG",
                        style: TextStyle(
                          color: Color(0xFF34495E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

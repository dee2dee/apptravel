import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:apptravel/features/auth/controllers/otp_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpController controller = Get.find<OtpController>();

  @override
  Widget build(BuildContext context) {
    // Ambil arguments dari Get
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final phone = args["phone"] ?? "";
    final expiredAt = args["expired_at"] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verifikasi OTP",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Obx(() => Text(
              "Masukan 6 digit kode yang sudah dikirim via\nWhatsApp ${controller.phoneNumber.value}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            )),

            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              onChanged: controller.updateOtp,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveColor: Colors.grey.shade300,
                selectedColor: Colors.green,
                activeColor: Colors.green,
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Verifikasi
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.verifyOtp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE67E22),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "VERIFIKASI",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                )),

            const SizedBox(height: 12),

            // Tombol Kirim Ulang
            TextButton(
              onPressed: () => controller.resendOtp(),
              child: const Text("KIRIM ULANG KODE"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apptravel/core/routes/app_routes.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo mobil blue
              SizedBox(
                height: width * 0.2,
                width: width * 0.2,
                child: Image.asset(
                  "assets/images/car_logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Judul
              const Text(
                "Azka Partner",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Tombol WhatsApp
              ElevatedButton.icon(
                icon: const Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)), // Warna hijau WhatsApp
                label: const Text(
                  "Masuk dengan WhatsApp",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34495E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.loginWa); // pakai GetX
                },
              ),
              const SizedBox(height: 24),

              // Garis pembatas dengan "ATAU"
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("ATAU"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),

              // Tombol Google & Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Tambahkan login Google
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 2),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/images/google_logo.png",
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Email Button
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(AppRoutes.login); // nanti bisa pakai GetX
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 2),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          "assets/images/email_icon.png",
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Link Daftar Sekarang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.register); // pakai GetX
                    },
                    child: const Text(
                      "DAFTAR SEKARANG",
                      style: TextStyle(
                          color: Color(0xFF34495E),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Catatan persyaratan
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Dengan melanjutkan, kamu telah membaca dan menyetujui "
                  "Persyaratan Penggunaan dan Kebijakan Privasi",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

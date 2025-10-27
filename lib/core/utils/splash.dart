import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:apptravel/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulasi loading 3 detik, lalu navigasi ke portal
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.portal); // pakai GetX untuk navigasi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              "assets/images/car_launcher.png", // ganti sesuai logo kamu
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40),
            // Progress Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34495E)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:apptravel/features/driver/controllers/driver_dashboard_controller.dart';

class DriverDashboard extends GetView<DriverDashboardController> {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF49A5F0),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: const [
                      PendapatanCard(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Obx(
      //   () => BottomNavigationBar(
      //     backgroundColor: const Color(0xFF49A5F0),
      //     currentIndex: controller.currentIndex.value,
      //     onTap: controller.changePage,
      //     selectedItemColor: Colors.white,
      //     unselectedItemColor: Colors.white70,
      //     type: BottomNavigationBarType.fixed,
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
      //       BottomNavigationBarItem(icon: Icon(Icons.book), label: "Booking"),
      //       BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Transfer bank"),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Obx(
        () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF34495E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF49A5F0),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.onItemTapped,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
                BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Pesanan"),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Transfer bank"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          )),
    );
  }
}

/// -------------------- HEADER --------------------
class HeaderSection extends GetView<DriverDashboardController> {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.directions_car,
                color: Color(0xFF49A5F0), size: 36),
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                controller.isLoadingX.value
                    ? "Hi.."
                    : "Hi.. ${controller.fullName.value}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )),
          const SizedBox(height: 4),
          const Text(
            "Selamat datang di Azka Partner",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// -------------------- PENDAPATAN CARD --------------------
class PendapatanCard extends GetView<DriverDashboardController> {
  const PendapatanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pendapatan"),
                  const SizedBox(height: 8),
                  Text(
                    controller.isVisible.value
                        ? controller.formatCurrency(controller.pendapatan.value)
                        : "Rp ******",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.toggleVisibility,
                child: Icon(
                  controller.isVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

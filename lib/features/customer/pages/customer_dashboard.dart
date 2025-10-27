import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:apptravel/features/customer/controllers/customer_dashboard_controller.dart';

class CustomerDashboardScreen extends GetView<CustomerDashboardController> {
  const CustomerDashboardScreen({super.key});

  Widget _shimmerBox({double? height, double? width, double? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height ?? 80.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius ?? 12.r),
        ),
      ),
    );
  }

  Widget _inputField({
    required IconData icon,
    required String hint,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF34495E),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 38.sp),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Text(
                            "Hi..",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                        return Text(
                          "Hi.. ${controller.fullName.value}",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                      SizedBox(height: 4.h),
                      Text(
                        "Selamat datang di Azka Partner",
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF34495E),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Obx(() => controller.isLoading.value
                          ? _shimmerBox(height: 200.h, radius: 16.r)
                          : Container(
                              margin: EdgeInsets.only(top: 12.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                children: [
                                  _inputField(
                                    icon: FontAwesomeIcons.locationDot,
                                    hint: "Keberangkatan",
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 12.h),
                                  _inputField(
                                    icon: FontAwesomeIcons.mapMarkerAlt,
                                    hint: "Tujuan",
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 12.h),
                                  _inputField(
                                    icon: FontAwesomeIcons.calendar,
                                    hint: "Kamis, 21 Agustus 2025",
                                    color: Colors.black87,
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48.h,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      child: Text(
                                        "CARI TIKET",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      SizedBox(height: 20.h),
                      Obx(() => controller.isLoading.value
                          ? _shimmerBox(height: 140.h, radius: 16.r)
                          : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 20.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tiket Travel",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF34495E),
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "Tiketmu, Petualanganmu",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 120.w,
                                      maxHeight: 100.h,
                                    ),
                                    child: Image.asset(
                                      "assets/images/travel_mockup.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.onItemTapped,
              selectedItemColor: const Color(0xFF2196F3),
              unselectedItemColor: const Color(0xFF9E9E9E),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.ticket), label: "Tiket"),
                BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Pesanan"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
              ],
            ),
          )),
    );
  }
}

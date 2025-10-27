import 'package:get/get.dart';
import 'package:apptravel/core/pages/portal.dart';
import 'package:apptravel/core/pages/register.dart';
import 'package:apptravel/core/utils/splash.dart';
import 'package:apptravel/core/bindings/register_binding.dart';
import 'package:apptravel/features/auth/pages/login_wa.dart';
import 'package:apptravel/features/auth/bindings/login_binding.dart';
import 'package:apptravel/features/auth/pages/otp_verification.dart';
import 'package:apptravel/features/auth/bindings/otp_binding.dart';
import 'package:apptravel/features/customer/pages/customer_dashboard.dart';
import 'package:apptravel/features/customer/bindings/customer_dashboard_binding.dart';
import 'package:apptravel/features/driver/pages/driver_dashboard.dart';
import 'package:apptravel/features/driver/bindings/driver_dashboard_binding.dart';
import 'package:apptravel/features/driver/pages/driver_account.dart';
import 'package:apptravel/features/driver/bindings/driver_account_info_binding.dart';

class AppRoutes {
  // Route names
  static const splash = "/";
  static const portal = "/portal";
  static const loginWa = "/loginWa";
  static const register = "/register";
  static const otpVerification = "/otp/verification";
  static const customerDashboard = "/customer/dashboard";
  static const driverDashboard = "/driver/dashboard";
  static const driverAccountInfo = "/driver-account-info";

  // GetX getPages
  static final getPages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: portal, page: () => const PortalScreen()),
    GetPage(name: loginWa, page: () => LoginScreenWA(), binding: LoginBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: otpVerification, page: () => OtpVerificationScreen(), binding: OtpBinding()),
    GetPage(name: customerDashboard, page: () => CustomerDashboardScreen(), binding: CustomerDashboardBinding()),
    GetPage(name: driverDashboard, page: () => DriverDashboard(), binding: DriverDashboardBinding()),
    GetPage(name: driverAccountInfo, page: () => DriverAccountInfoScreen(), binding: DriverAccountInfoBinding()),

  ];
}

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:apptravel/features/customer/models/model.dart';

class DeviceUtils {
  static Future<Device> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      final deviceId = (android.id != null && android.id!.isNotEmpty)
          ? android.id!
          : "emulator_${const Uuid().v4()}"; // Gunakan UUID jika id null atau kosong
      return Device(
        deviceId: deviceId,
        platform: "android",
        model: android.model ?? "",
        brand: android.brand ?? "",
        osVersion: "Android ${android.version.release ?? 'Unknown'}",
      );
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      final deviceId = ios.identifierForVendor?.isNotEmpty == true
          ? ios.identifierForVendor!
          : "ios_${const Uuid().v4()}";
      return Device(
        deviceId: deviceId,
        platform: "ios",
        model: ios.utsname.machine ?? "Unknown",
        brand: "Apple",
        osVersion: "iOS ${ios.systemVersion}",
      );
    } else {

      // fallback kalau platform lain
      return Device(
        deviceId: "unknown_${const Uuid().v4()}",
        platform: "unknown",
        model: "unknown",
        brand: "unknown",
        osVersion: "unknown",
      );
    }
  }
}

// ========================
//  USER MODEL
// ========================
class User {
  final String fullName;
  final String gender;
  final String email;
  final String phone;
  final String password;
  final String role;
  final Device device;

  User({
    required this.fullName,
    required this.gender,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    required this.device,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'gender': gender,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'device': device.toJson(),
    };
  }
}


// ========================
//  DEVICE MODEL
// ========================
class Device {
  final String deviceId;
  final String platform;
  final String model;
  final String brand;
  final String osVersion;
  final bool isTrusted;

  Device({
    required this.deviceId,
    required this.platform,
    required this.model,
    required this.brand,
    required this.osVersion,
    this.isTrusted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'platform': platform,
      'model': model,
      'brand': brand,
      'os_version': osVersion,
      'is_trusted': isTrusted,
    };
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:apptravel/features/customer/models/model.dart';

class ApiService {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';

  static Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "X-API-KEY": _apiKey,
      };

  /// Register user
  static Future<Map<String, dynamic>> registerUser(User user) async {
    final url = Uri.parse("$_baseUrl/otp/register");

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(user.toJson()), // 👈 langsung pakai model User
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal register: ${response.body}");
    }
  }

  /// Generate OTP
  static Future<Map<String, dynamic>> generateOTP(String phone, String deviceRef) async {
    final url = Uri.parse("$_baseUrl/otp/generate");

    // Untuk testing
    final body = {
      "phone": phone,
      "device_id": deviceRef, // OTP statis untuk testing
    };

    print("Request OTP body: $body");

    final response = await http.post(
      url,
      headers: _headers,
      // body: jsonEncode({"phone": phone}),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal generate OTP: ${response.body}");
    }
  }

  /// Verify OTP
  static Future<Map<String, dynamic>> verifyOTP(int userId, String otp, String deviceRef) async {
    final url = Uri.parse("$_baseUrl/otp/verification");

    print("Verify OTP body: ${jsonEncode({
      "user_id": userId,
      "otp": otp,
      "device_ref": deviceRef,
    })}");

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        "user_id": userId,
        "otp": otp,
        "device_ref": deviceRef,
        }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Simpan token ke secure storage kalau ada
      if (data["token"] != null) {
        const storage = FlutterSecureStorage();
        await storage.write(key: "token", value: data["token"]);
        if (data["refresh_token"] != null) {
          await storage.write(key: "refresh_token", value: data["refresh_token"]);
        }
      }

      return data;
    } else {
      throw Exception("Gagal verifikasi OTP: ${response.body}");
    }
  }
    
  /// Logout user
  static Future<bool> logout() async {
    const storage = FlutterSecureStorage();

    // ambil token dari secure storage
    final token = await storage.read(key: "token");

    if (token == null) return false;

    final url = Uri.parse("$_baseUrl/auth/logout");

    final response = await http.post(
      url,
      headers: {
        ..._headers,
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      // hapus token dari secure storage
      await storage.delete(key: "token");
      await storage.delete(key: "refresh_token");
      return true;
    } else {
      return false;
    }
  }

  /// Get user
  // static Future<Map<String, dynamic>?> getUser() async {
  //   try {
  //     final response = await http.get(Uri.parse('$_baseUrl/auth/users'));

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['full_name'] != null) {
  //         return data;
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     print("Error getUser: $e");
  //     return null;
  //   }
  // }
  /// Get user
  static Future<Map<String, dynamic>?> getUser() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: "token");

      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/users'),
        headers: {
          ..._headers,
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // langsung return semua data (full_name, email, phone)
      }
      return null;
    } catch (e) {
      print("Error getUser: $e");
      return null;
    }
  }


}

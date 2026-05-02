import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgetPasswordService {
  static const String _baseUrl = "https://backend.stem-flow.com/api";

  /// ================= FORGOT PASSWORD =================
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    print("Forgot password API calling...");
    print("Email: $email");

    final response = await http.post(
      Uri.parse("$_baseUrl/forgot-password"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    print("Forgot password status: ${response.statusCode}");
    print("Forgot password body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }

  /// ================= RESET PASSWORD =================
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
    required int userId,
  }) async {
    print("Reset password API calling...");
    print("Email: $email");
    print("OTP: $otp");
    print("User ID: $userId");

    final response = await http.post(
      Uri.parse("$_baseUrl/reset-password"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "otp": int.parse(otp), // important
        "new_password": newPassword,
        "new_password_confirmation": confirmPassword,
        "user_id": userId,
      }),
    );

    print("Reset password status: ${response.statusCode}");
    print("Reset password body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Password reset failed");
    }
  }
}
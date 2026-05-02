import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  static const String _url =
      "https://backend.stem-flow.com/api/change-password";

  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      print("Change Password API Calling...");
      print("URL: $_url");

      final body = {
        "user_id": userId,
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_password_confirmation": confirmPassword,
      };

      print("Request Body: $body");

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      return {
        "success": response.statusCode == 200 && data["status"] == 200,
        "message": data["message"] ?? "Something went wrong",
        "data": data,
      };
    } catch (e) {
      print("Change Password Error: $e");

      return {
        "success": false,
        "message": "Something went wrong. Please try again.",
      };
    }
  }
}
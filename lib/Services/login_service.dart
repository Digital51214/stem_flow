import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String loginUrl = "https://backend.stem-flow.com/api/signin";

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };

      print("=== LOGIN API CALLED ===");
      print("URL: $loginUrl");
      print("Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("=== LOGIN API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": decodedResponse["message"] ?? "Login successful",
          "user": decodedResponse["user"],
          "data": decodedResponse,
        };
      } else {
        String errorMessage = decodedResponse["message"] ?? "Login failed";

        if (decodedResponse["errors"] != null &&
            decodedResponse["errors"] is Map) {
          final errors = decodedResponse["errors"] as Map<String, dynamic>;

          if (errors.isNotEmpty) {
            final firstKey = errors.keys.first;
            final firstValue = errors[firstKey];

            if (firstValue is List && firstValue.isNotEmpty) {
              errorMessage = firstValue.first.toString();
            } else {
              errorMessage = firstValue.toString();
            }
          }
        }

        return {
          "success": false,
          "message": errorMessage,
          "data": decodedResponse,
        };
      }
    } catch (e) {
      print("=== LOGIN API ERROR ===");
      print("Error: $e");

      return {
        "success": false,
        "message": "Something went wrong: $e",
      };
    }
  }
}
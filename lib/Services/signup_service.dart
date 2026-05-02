import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String signupUrl = "https://backend.stem-flow.com/api/signup";

  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "username": username,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

      print("=== SIGNUP API CALLED ===");
      print("URL: $signupUrl");
      print("Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("=== SIGNUP API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": decodedResponse["message"] ?? "Signup successful",
          "data": decodedResponse,
        };
      } else {
        String errorMessage = decodedResponse["message"] ?? "Signup failed";

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
      print("=== SIGNUP API ERROR ===");
      print("Error: $e");

      return {
        "success": false,
        "message": "Something went wrong: $e",
      };
    }
  }
}
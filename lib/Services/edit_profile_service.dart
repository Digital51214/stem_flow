import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileService {
  static const String editProfileUrl =
      "https://backend.stem-flow.com/api/edit-profile";

  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String fullName,
    required String profilePicBase64,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "user_id": int.tryParse(userId) ?? 0,
        "full_name": fullName,
        "profile_pic": profilePicBase64,
      };

      print("=== EDIT PROFILE API CALLED ===");
      print("URL: $editProfileUrl");
      print("Request Body: ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(editProfileUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("=== EDIT PROFILE API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": decodedResponse["message"] ?? "Profile updated successfully",
          "data": decodedResponse,
        };
      } else {
        String errorMessage =
            decodedResponse["message"] ?? "Profile update failed";

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
      print("=== EDIT PROFILE API ERROR ===");
      print("Error: $e");

      return {
        "success": false,
        "message": "Something went wrong: $e",
      };
    }
  }
}
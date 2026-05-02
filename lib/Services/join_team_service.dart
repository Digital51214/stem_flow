import 'dart:convert';
import 'package:http/http.dart' as http;

class JoinTeamService {
  static const String _baseUrl = "https://backend.stem-flow.com/api/join-team";

  static Future<Map<String, dynamic>> joinTeam({
    required int userId,
    required String inviteCode,
  }) async {
    try {
      print("Join Team API Calling...");
      print("User ID: $userId");
      print("Invite Code: $inviteCode");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "invite_code": inviteCode,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      print("Join Team API Error: $e");
      return {
        "status": 500,
        "message": "Something went wrong!",
      };
    }
  }
}
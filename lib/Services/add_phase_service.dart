import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPhaseService {
  static const String _baseUrl =
      "https://backend.stem-flow.com/api/add-phase";

  static Future<Map<String, dynamic>> addPhase({
    required int userId,
    required int teamId,
    required int projectId,
    required String phaseName,
    required String phaseDescription,
    required String apiKey,
  }) async {
    try {
      print("Add Phase API Calling...");
      print("URL: $_baseUrl");
      print("user_id: $userId");
      print("team_id: $teamId");
      print("project_id: $projectId");
      print("phase_name: $phaseName");
      print("phase_description: $phaseDescription");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "user_id": userId,
          "team_id": teamId,
          "project_id": projectId,
          "phase_name": phaseName,
          "phase_description": phaseDescription,
        }),
      );

      print("Add Phase Status Code: ${response.statusCode}");
      print("Add Phase Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": data["message"] ?? "Phase Added!",
          "data": data,
        };
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Failed to add phase",
          "data": data,
        };
      }
    } catch (e) {
      print("Add Phase API Error: $e");

      return {
        "success": false,
        "message": "Network error. Please try again.",
        "data": null,
      };
    }
  }
}
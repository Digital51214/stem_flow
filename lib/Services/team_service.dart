import 'dart:convert';
import 'package:http/http.dart' as http;

class TeamService {
  static const String _baseUrl = "https://backend.stem-flow.com/api/create-team";

  static Future<Map<String, dynamic>> createTeam({
    required int userId,
    required String teamName,
    required String year,
    required String description,
    required String iconBase64,
  }) async {
    try {
      print("Create Team API Calling...");
      print("Team Name: $teamName");
      print("Year: $year");
      print("Description: $description");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "team_name": teamName,
          "year": year,
          "description": description,
          "icon": iconBase64,
        }),
      );

      print("Create Team Status Code: ${response.statusCode}");
      print("Create Team Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": data,
          "message": data["message"] ?? "Team Created Successfully!",
        };
      } else {
        return {
          "success": false,
          "data": data,
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      print("Create Team API Error: $e");

      return {
        "success": false,
        "data": null,
        "message": "Network error. Please try again.",
      };
    }
  }
}
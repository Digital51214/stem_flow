import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/teams_models.dart';


class MyTeamService {
  static const String _baseUrl =
      "https://backend.stem-flow.com/api/my-teams";

  static Future<List<MyTeamModel>> getMyTeams({
    required int userId,
    required String apiKey,
  }) async {
    try {
      print("My Teams API Calling...");
      print("URL: $_baseUrl");
      print("Body: {user_id: $userId}");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      print("My Teams Status Code: ${response.statusCode}");
      print("My Teams Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        final List teams = data["my_teams"] ?? [];

        print("Total Teams Found: ${teams.length}");

        return teams.map((e) => MyTeamModel.fromJson(e)).toList();
      } else {
        print("My Teams API Error: ${data["message"] ?? "Something went wrong"}");
        throw Exception(data["message"] ?? "Failed to load teams");
      }
    } catch (e) {
      print("My Teams API Exception: $e");
      throw Exception("Network error. Please try again.");
    }
  }
}
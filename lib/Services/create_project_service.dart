import 'dart:convert';
import 'package:http/http.dart' as http;

class ProjectService {
  static const String _baseUrl =
      "https://backend.stem-flow.com/api/projects/store";

  static Future<Map<String, dynamic>> createProject({
    required int userId,
    required String projectName,
    required String description,
  }) async {
    try {
      print("Create Project API Calling...");
      print("URL: $_baseUrl");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "project_name": projectName,
          "description": description,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data["message"] ?? "Something went wrong");
      }
    } catch (e) {
      print("Create Project Error: $e");
      throw Exception(e.toString());
    }
  }
}
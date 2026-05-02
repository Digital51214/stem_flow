import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/project_model.dart';


class ShowProjectService {
  static const String _baseUrl =
      'https://backend.stem-flow.com/api/projects/user-projects';

  static Future<List<ProjectModel>> getUserProjects({
    required int userId,
    required String apiKey,
  }) async {
    try {
      print('Calling user projects API...');
      print('URL: $_baseUrl');
      print('Body: {"user_id": $userId}');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List data = decoded['data'] ?? [];

        print('Projects found: ${data.length}');

        return data.map((e) => ProjectModel.fromJson(e)).toList();
      } else {
        print('API Error: ${decoded['message'] ?? 'Something went wrong'}');
        throw Exception(decoded['message'] ?? 'Failed to load projects');
      }
    } catch (e) {
      print('Project API Exception: $e');
      throw Exception('Failed to load projects');
    }
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectService {
  static Future<Map<String, dynamic>> getProjectPhases({
    required int userId,
    required int projectId,
    required String apiKey,
  }) async {
    final url = Uri.parse('https://backend.stem-flow.com/api/phases/get-by-project');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'user_id': userId,
        'project_id': projectId,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      // Here, you can set the body or result
      if (result['success']) {
        return result; // You can extract the relevant phase data here if needed
      } else {
        throw Exception('Failed to retrieve phases: ${result['message']}');
      }
    } else {
      throw Exception('Failed to load phases');
    }
  }
}
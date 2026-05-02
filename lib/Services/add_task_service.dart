import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTaskService {
  static const String _baseUrl = 'https://backend.stem-flow.com/api';

  /// Returns the created task map on success.
  /// Throws a [String] error message on failure.
  static Future<Map<String, dynamic>> addTask({
    required int userId,
    required int teamId,
    required int phaseId,
    required String title,
    required String priority,   // "low" | "medium" | "high"
    required String deadline,   // "yyyy-MM-dd"
  }) async {
    final Uri url = Uri.parse('$_baseUrl/add-task');

    final Map<String, dynamic> body = {
      "user_id": userId,
      "team_id": teamId,
      "phase_id": phaseId,
      "title": title,
      "priority": priority.toLowerCase(),
      "deadline": deadline,
    };

    print('[AddTaskService] POST $url');
    print('[AddTaskService] Body: ${jsonEncode(body)}');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('[AddTaskService] Status: ${response.statusCode}');
    print('[AddTaskService] Response: ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return decoded['task'] as Map<String, dynamic>;
    }

    // Server returned a non-201 code — surface the message if available
    final String message =
        decoded['message']?.toString() ?? 'Failed to create task';
    throw message;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskModel {
  final int id;
  final int phaseId;
  final String title;
  final String deadline;
  final String status;
  final String priority;
  final String createdAt;
  final String updatedAt;

  const TaskModel({
    required this.id,
    required this.phaseId,
    required this.title,
    required this.deadline,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      phaseId: json['phase_id'] as int,
      title: json['title'] as String,
      deadline: json['deadline'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class GetTasksService {
  static const String _baseUrl = 'https://backend.stem-flow.com/api';

  /// Returns list of [TaskModel] on success.
  /// Throws a [String] error message on failure.
  static Future<List<TaskModel>> getTasks({
    required int teamId,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/get-tasks');

    final Map<String, dynamic> body = {
      "team_id": teamId,
    };

    print('[GetTasksService] POST $url');
    print('[GetTasksService] Body: ${jsonEncode(body)}');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('[GetTasksService] Status: ${response.statusCode}');
    print('[GetTasksService] Response: ${response.body}');

    final Map<String, dynamic> decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> taskList = decoded['tasks'] as List<dynamic>;
      return taskList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final String message =
        decoded['message']?.toString() ?? 'Failed to fetch tasks';
    throw message;
  }
}
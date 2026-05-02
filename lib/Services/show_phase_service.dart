import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phase_model.dart';

class ShowPhaseService {
  static const String _baseUrl = 'https://backend.stem-flow.com/api';

  static Future<List<PhaseModel>> getProjectPhases({
    required int userId,
    required int projectId,
  }) async {
    final uri = Uri.parse('$_baseUrl/phases/get-by-project');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'project_id': projectId,
      }),
    );

    print('[ShowPhaseService] Status: ${response.statusCode}');
    print('[ShowPhaseService] Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        final List<dynamic> data = body['data'] as List<dynamic>;
        return data
            .map((e) => PhaseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error: ${body['message'] ?? 'Failed to fetch phases'}');
      }
    } else {
      throw Exception(
        'Server error: ${response.statusCode}. Response: ${response.body}',
      );
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/team_event_model.dart';

class ShowTeamEventService {
  static const String _url =
      'https://backend.stem-flow.com/api/team/events';

  static Future<TeamEventsModel> getTeamEvents({
    required int teamId,
    required String apiKey,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'team_id': teamId,
      }),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded['status'] == 200) {
      return TeamEventsModel.fromJson(decoded);
    } else {
      throw Exception(decoded['message'] ?? 'Failed to load events');
    }
  }
}
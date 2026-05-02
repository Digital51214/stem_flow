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
    try {
      print('Calling Team Events API...');
      print('URL: $_url');
      print('Body: {"team_id": $teamId}');

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

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == 200) {
        print('Team events loaded successfully');
        return TeamEventsModel.fromJson(decoded);
      } else {
        print('API Error: ${decoded['message'] ?? 'Something went wrong'}');
        throw Exception(decoded['message'] ?? 'Failed to load events');
      }
    } catch (e) {
      print('Team Events Exception: $e');
      throw Exception('Failed to load events');
    }
  }
}
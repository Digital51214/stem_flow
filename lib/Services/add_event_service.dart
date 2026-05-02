import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEventService {
  static const String _url =
      "https://backend.stem-flow.com/api/team/events/add";

  static Future<Map<String, dynamic>> addEvent({
    required int teamId,
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      print("Add Event API Calling...");
      print("URL: $_url");
      print("Body: team_id=$teamId, title=$title, date=$date, time=$time");

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "team_id": teamId,
          "title": title,
          "date": date,
          "time": time,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data["message"] ?? "Failed to add event");
      }
    } catch (e) {
      print("Add Event Service Error: $e");
      throw Exception(e.toString());
    }
  }
}
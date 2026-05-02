import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  static Future<Map<String, dynamic>> fetchHomeData({required int teamId}) async {
    final url = Uri.parse("https://backend.stem-flow.com/api/home-data");

    final body = {
      "team_id": teamId,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;  // Return the parsed response
    } else {
      throw Exception(data["message"] ?? "Failed to fetch home data");
    }
  }
}
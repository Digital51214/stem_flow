import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {
  static const String _url =
      "https://backend.stem-flow.com/api/team/budget-details";

  static Future<Map<String, dynamic>> getBudgetDetails({
    required int teamId,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "team_id": teamId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Failed to load budget details");
    }
  }
}
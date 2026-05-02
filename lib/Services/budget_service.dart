import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {
  static Future<Map<String, dynamic>> getBudgetDetails({
    required int teamId,
  }) async {
    final url = Uri.parse("https://backend.stem-flow.com/api/team/budget-details");

    final body = {
      "team_id": teamId,
    };

    print("📤 BUDGET REQUEST URL: $url");
    print("📤 BUDGET REQUEST BODY: $body");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("📥 BUDGET RESPONSE STATUS: ${response.statusCode}");
    print("📥 BUDGET RESPONSE BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Failed to load budget details");
    }
  }
}
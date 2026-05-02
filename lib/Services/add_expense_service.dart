import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpenseService {
  static Future<Map<String, dynamic>> addExpense({
    required int teamId,
    required String itemName,
    required String category,
    required double amount,
    required String date,
  }) async {
    final url = Uri.parse("https://backend.stem-flow.com/api/expenses/add");

    final body = {
      "team_id": teamId,
      "item_name": itemName,
      "category": category,
      "amount": amount,
      "date": date,
    };

    print("📤 REQUEST BODY: $body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("📥 RESPONSE STATUS: ${response.statusCode}");
    print("📥 RESPONSE BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "API Error");
    }
  }
}
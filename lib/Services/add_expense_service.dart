import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpenseService {
  static const String _url =
      "https://backend.stem-flow.com/api/expenses/add";

  static Future<Map<String, dynamic>> addExpense({
    required int teamId,
    required String itemName,
    required String category,
    required double amount,
    required String date,
  }) async {
    final body = {
      "team_id": teamId,
      "item_name": itemName,
      "category": category,
      "amount": amount,
      "date": date,
    };

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data["status"] == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Failed to add expense");
    }
  }
}
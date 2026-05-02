import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteAccountService {
  static const String _baseUrl = 'https://backend.stem-flow.com/api';

  static Future<void> deleteAccount({required int userId}) async {
    final uri = Uri.parse('$_baseUrl/users/delete');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    print('[DeleteAccountService] Status: ${response.statusCode}');
    print('[DeleteAccountService] Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['success'] == true) {
        return; // success
      } else {
        throw Exception(body['message'] ?? 'Failed to delete account');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
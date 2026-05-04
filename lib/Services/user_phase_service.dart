import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_phase_model.dart';

class UserPhaseService {
  static const String _url =
      'https://backend.stem-flow.com/api/phases/user-phases';

  static Future<List<UserPhaseModel>> getUserPhases({
    required int userId,
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
        'user_id': userId,
      }),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded['success'] == true) {
      final List data = decoded['data'] ?? [];
      return data.map((e) => UserPhaseModel.fromJson(e)).toList();
    } else {
      throw Exception(decoded['message'] ?? 'Failed to load phases');
    }
  }
}
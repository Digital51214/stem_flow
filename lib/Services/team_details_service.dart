import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/member_model.dart';

class GetTeamMembersService {
  static const String _baseUrl =
      'https://backend.stem-flow.com/api/team-details';

  static Future<List<MemberModel>> getMembers({
    required int teamId,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'team_id': teamId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['status'] == 200) {
        final List<dynamic> members = body['members'] as List<dynamic>;
        return members
            .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Failed to fetch members');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
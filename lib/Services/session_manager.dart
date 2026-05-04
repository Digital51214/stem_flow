import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  SessionManager._internal();

  static final SessionManager instance = SessionManager._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserData = "user_data";
  static const String _keyUserId = "user_id";
  static const String _keyTeamId = "team_id";
  static const String _keyUsername = "username";
  static const String _keyFullName = "full_name";
  static const String _keyEmail = "email";
  static const String _keyProfilePic = "profile_pic";
  static const String _keyIsPro = "is_pro";
  static const String _keyCreatedAt = "created_at";
  static const String _keyUpdatedAt = "updated_at";

  String _safeValue(dynamic value) {
    if (value == null) return "";
    if (value.toString().toLowerCase() == "null") return "";
    return value.toString();
  }

  Future<void> saveUserSession(Map<String, dynamic> user) async {
    try {
      print("=== SAVE USER SESSION START ===");
      print("Incoming User Data: $user");

      final userId = _safeValue(user["id"]);
      final teamId = _safeValue(user["team_id"]);
      final username = _safeValue(user["username"]);
      final fullName = _safeValue(user["full_name"]);
      final email = _safeValue(user["email"]);
      final profilePic = _safeValue(user["profile_pic"]);
      final isPro = _safeValue(user["is_pro"]);
      final createdAt = _safeValue(user["created_at"]);
      final updatedAt = _safeValue(user["updated_at"]);

      final normalizedUser = {
        "id": userId,
        "team_id": teamId,
        "username": username,
        "full_name": fullName,
        "email": email,
        "profile_pic": profilePic,
        "is_pro": isPro,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

      await _storage.write(key: _keyIsLoggedIn, value: "true");
      await _storage.write(key: _keyUserData, value: jsonEncode(normalizedUser));
      await _storage.write(key: _keyUserId, value: userId);
      await _storage.write(key: _keyTeamId, value: teamId);
      await _storage.write(key: _keyUsername, value: username);
      await _storage.write(key: _keyFullName, value: fullName);
      await _storage.write(key: _keyEmail, value: email);
      await _storage.write(key: _keyProfilePic, value: profilePic);
      await _storage.write(key: _keyIsPro, value: isPro);
      await _storage.write(key: _keyCreatedAt, value: createdAt);
      await _storage.write(key: _keyUpdatedAt, value: updatedAt);

      print("=== SAVE USER SESSION SUCCESS ===");
      print("Saved user_id: $userId");
      print("Saved team_id: $teamId");
      print("Saved full_name: $fullName");
      print("Saved email: $email");
    } catch (e) {
      print("=== SAVE USER SESSION ERROR ===");
      print("Error: $e");
    }
  }

  Future<void> saveTeamId(dynamic teamId) async {
    final value = _safeValue(teamId);
    await _storage.write(key: _keyTeamId, value: value);
    print("Saved team_id: $value");
  }

  Future<int> getTeamId() async {
    try {
      final value = await _storage.read(key: _keyTeamId) ?? "";
      print("getTeamId: $value");
      return int.tryParse(value) ?? 0;
    } catch (e) {
      print("=== GET TEAM ID ERROR ===");
      print("Error: $e");
      return 0;
    }
  }

  Future<void> updateProfileSession({
    required String fullName,
    required String profilePic,
  }) async {
    try {
      print("=== UPDATE PROFILE SESSION START ===");
      print("New Full Name: $fullName");
      print("New Profile Pic: $profilePic");

      final existingData = await getUserData() ?? {};

      final updatedUser = {
        ...existingData,
        "full_name": fullName,
        "profile_pic": profilePic,
      };

      await _storage.write(key: _keyFullName, value: fullName);
      await _storage.write(key: _keyProfilePic, value: profilePic);
      await _storage.write(key: _keyUserData, value: jsonEncode(updatedUser));

      print("=== UPDATE PROFILE SESSION SUCCESS ===");
      print("Updated User Data: $updatedUser");
    } catch (e) {
      print("=== UPDATE PROFILE SESSION ERROR ===");
      print("Error: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final value = await _storage.read(key: _keyIsLoggedIn);
      print("=== CHECK LOGIN STATUS ===");
      print("is_logged_in: $value");
      return value == "true";
    } catch (e) {
      print("=== CHECK LOGIN STATUS ERROR ===");
      print("Error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _storage.read(key: _keyUserData);

      print("=== GET USER DATA ===");
      print("Raw User Data: $data");

      if (data == null || data.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(data) as Map<String, dynamic>;
      print("Decoded User Data: $decoded");
      return decoded;
    } catch (e) {
      print("=== GET USER DATA ERROR ===");
      print("Error: $e");
      return null;
    }
  }

  Future<String> getUserId() async {
    try {
      final value = await _storage.read(key: _keyUserId) ?? "";
      print("getUserId: $value");
      return value;
    } catch (e) {
      print("=== GET USER ID ERROR ===");
      print("Error: $e");
      return "";
    }
  }

  Future<String> getUsername() async {
    try {
      final value = await _storage.read(key: _keyUsername) ?? "";
      print("getUsername: $value");
      return value;
    } catch (e) {
      print("=== GET USERNAME ERROR ===");
      print("Error: $e");
      return "";
    }
  }

  Future<String> getFullName() async {
    try {
      final value = await _storage.read(key: _keyFullName) ?? "";
      print("getFullName: $value");
      return value;
    } catch (e) {
      print("=== GET FULL NAME ERROR ===");
      print("Error: $e");
      return "";
    }
  }

  Future<String> getEmail() async {
    try {
      final value = await _storage.read(key: _keyEmail) ?? "";
      print("getEmail: $value");
      return value;
    } catch (e) {
      print("=== GET EMAIL ERROR ===");
      print("Error: $e");
      return "";
    }
  }

  Future<String> getProfilePic() async {
    try {
      final value = await _storage.read(key: _keyProfilePic) ?? "";
      print("getProfilePic: $value");
      return value;
    } catch (e) {
      print("=== GET PROFILE PIC ERROR ===");
      print("Error: $e");
      return "";
    }
  }

  Future<void> clearSession() async {
    try {
      print("=== CLEAR SESSION START ===");
      await _storage.deleteAll();
      print("=== CLEAR SESSION SUCCESS ===");
    } catch (e) {
      print("=== CLEAR SESSION ERROR ===");
      print("Error: $e");
    }
  }
}
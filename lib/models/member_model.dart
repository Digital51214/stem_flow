class MemberModel {
  final int id;
  final String username;
  final String? profilePic;
  final String role;
  final String status;

  MemberModel({
    required this.id,
    required this.username,
    required this.profilePic,
    required this.role,
    required this.status,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      username: json['username'] as String,
      profilePic: json['profile_pic'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
    );
  }

  // Full image URL helper
  String? get profilePicUrl {
    if (profilePic == null) return null;
    return 'https://backend.stem-flow.com/storage/$profilePic';
  }
}
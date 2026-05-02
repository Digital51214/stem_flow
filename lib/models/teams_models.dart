class MyTeamModel {
  final int id;
  final String name;
  final String year;
  final String description;
  final String icon;
  final String inviteCode;
  final int creatorId;
  final String totalBudget;
  final String materialsSpent;
  final String createdAt;
  final String updatedAt;

  MyTeamModel({
    required this.id,
    required this.name,
    required this.year,
    required this.description,
    required this.icon,
    required this.inviteCode,
    required this.creatorId,
    required this.totalBudget,
    required this.materialsSpent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) {
    return MyTeamModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      year: json["year"] ?? "",
      description: json["description"] ?? "",
      icon: json["icon"] ?? "",
      inviteCode: json["invite_code"] ?? "",
      creatorId: json["creator_id"] ?? 0,
      totalBudget: json["total_budget"] ?? "0.00",
      materialsSpent: json["materials_spent"] ?? "0.00",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}
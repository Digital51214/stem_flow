class ProjectModel {
  final int id;
  final int userId;
  final String projectName;
  final String description;
  final String createdAt;
  final String updatedAt;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.projectName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      projectName: json['project_name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
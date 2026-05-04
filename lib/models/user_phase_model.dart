class UserPhaseModel {
  final int id;
  final int projectId;
  final int teamId;
  final String phaseName;
  final int progressPercentage;
  final String phaseDescription;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  UserPhaseModel({
    required this.id,
    required this.projectId,
    required this.teamId,
    required this.phaseName,
    required this.progressPercentage,
    required this.phaseDescription,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPhaseModel.fromJson(Map<String, dynamic> json) {
    return UserPhaseModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      phaseName: json['phase_name'] ?? '',
      progressPercentage: json['progress_percentage'] ?? 0,
      phaseDescription: json['phase_description'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
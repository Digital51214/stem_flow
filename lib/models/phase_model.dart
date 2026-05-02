class PhaseModel {
  final int id;
  final int projectId;
  final int teamId;
  final String phaseName;
  final double progressPercentage;
  final String? phaseDescription;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PhaseModel({
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

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      teamId: json['team_id'] as int,
      phaseName: json['phase_name'] as String,
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      phaseDescription: json['phase_description'] as String?,
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
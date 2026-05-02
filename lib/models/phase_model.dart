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
    this.phaseDescription, // Keep phaseDescription nullable
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    try {
      return PhaseModel(
        id: json['id'] as int,
        projectId: json['project_id'] as int,
        teamId: json['team_id'] as int,
        phaseName: json['phase_name'] as String,
        progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0.0, // null-safe
        phaseDescription: json['phase_description'] as String?, // Allow for nullable description
        isActive: json['is_active'] == 1, // Checking if `is_active` is 1 for true
        createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(), // Handle potential parsing errors
        updatedAt: DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now(), // Default to current date if parsing fails
      );
    } catch (e) {
      print('Error parsing PhaseModel: $e');
      rethrow; // Re-throw to let the calling function know
    }
  }
}
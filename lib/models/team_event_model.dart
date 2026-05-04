class ActiveSprintModel {
  final String title;
  final String subtitle;
  final String membersLabel;
  final bool isActive;

  ActiveSprintModel({
    required this.title,
    required this.subtitle,
    required this.membersLabel,
    required this.isActive,
  });

  factory ActiveSprintModel.fromJson(Map<String, dynamic> json) {
    return ActiveSprintModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      membersLabel: json['members_label'] ?? '+0',
      isActive: json['is_active'] ?? false,
    );
  }
}

class UpcomingScheduleModel {
  final int id;
  final String title;
  final String date;
  final String time;

  UpcomingScheduleModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
  });

  factory UpcomingScheduleModel.fromJson(Map<String, dynamic> json) {
    return UpcomingScheduleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}

class TeamEventsModel {
  final ActiveSprintModel? activeSprint;
  final List<UpcomingScheduleModel> upcomingSchedule;

  TeamEventsModel({
    required this.activeSprint,
    required this.upcomingSchedule,
  });

  factory TeamEventsModel.fromJson(Map<String, dynamic> json) {
    return TeamEventsModel(
      activeSprint: json['active_sprint'] != null
          ? ActiveSprintModel.fromJson(json['active_sprint'])
          : null,
      upcomingSchedule: (json['upcoming_schedule'] as List? ?? [])
          .map((e) => UpcomingScheduleModel.fromJson(e))
          .toList(),
    );
  }
}
class PlantGroup {
  final int idGroup;
  final String title;
  final bool isActive;
  final bool isStandard;
  final GroupDetails details;

  PlantGroup({
    required this.idGroup,
    required this.title,
    required this.isActive,
    required this.isStandard,
    required this.details,
  });

  factory PlantGroup.fromJson(Map<String, dynamic> json) {
    return PlantGroup(
      idGroup: json['id_group'],
      title: json['title'] ?? '',
      isActive: json['is_active'] ?? false,
      isStandard: json['is_standard'] ?? false,
      details: GroupDetails.fromJson(json['details'] ?? {}),
    );
  }
}

class GroupDetails {
  final String? fertility;
  final String? temperature;
  final String? humidityAir;
  final String? humidityGround;
  final int? wateringTime;
  final int? priority;

  GroupDetails({
    this.fertility,
    this.temperature,
    this.humidityAir,
    this.humidityGround,
    this.wateringTime,
    this.priority,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      fertility: json['fertility']?.toString(),
      temperature: json['temperature']?.toString(),
      humidityAir: json['humidity_air']?.toString(),
      humidityGround: json['humidity_ground']?.toString(),
      wateringTime: json['watering_time'] is int ? json['watering_time'] : null,
      priority: json['priority'],
    );
  }
}
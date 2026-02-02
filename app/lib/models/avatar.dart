class Avatar {
  final int idAvatar;
  final String title;
  final String description;
  final String picturePath;
  final int? evolutionNumber;
  final int state;
  final int idPlantType;

  Avatar({
    required this.idAvatar,
    required this.title,
    required this.description,
    required this.picturePath,
    this.evolutionNumber,
    required this.state,
    required this.idPlantType,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      idAvatar: json['id_avatar'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      picturePath: json['picture_path'] ?? '',
      evolutionNumber: json['evolution_number'],
      state: json['state'] ?? 0,
      idPlantType: json['id_plant_type'] ?? 0,
    );
  }
}
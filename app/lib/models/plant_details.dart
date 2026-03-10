class PlantDetails {
  final int typeId;
  final String typeTitle;
  final String groupTitle;
  final String? imagePath;

  PlantDetails({
    required this.typeId,
    required this.typeTitle,
    required this.groupTitle,
    this.imagePath,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    return PlantDetails(
      typeId: json['type_id'],
      typeTitle: json['type_title'] ?? '',
      groupTitle: json['group_title'] ?? '',
      imagePath: json['image_path'],
    );
  }

  factory PlantDetails.empty() {
    return PlantDetails(
      typeId: 0,
      typeTitle: 'Inconnu',
      groupTitle: 'Inconnu',
      imagePath: null,
    );
  }
}
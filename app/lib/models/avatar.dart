class Avatar {
  final int idAvatar;
  final String title;
  final String description;
  final String pathPicture; // Changé ici
  final int? evolution; // Correspond à l'API
  final int state;

  Avatar({
    required this.idAvatar,
    required this.title,
    required this.description,
    required this.pathPicture,
    this.evolution,
    required this.state,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      idAvatar: json['id_avatar'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pathPicture: json['path_picture'] ?? '',
      evolution: json['evolution'],
      state: json['state'] ?? 0,
    );
  }
}
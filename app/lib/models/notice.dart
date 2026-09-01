class Notice {
  final int idNotice;
  final String title;
  final String content;
  final String status;
  final String createdAt;
  final bool isPublic;
  final String? objectProfileTitle;
  final String tagName;

  Notice({
    required this.idNotice,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.isPublic,
    this.objectProfileTitle,
    required this.tagName,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      idNotice: json['id_notice'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? 'PENDING',
      createdAt: json['created_at'] ?? '',
      isPublic: json['is_public'] ?? false,
      objectProfileTitle: json['object_profile_title'],
      tagName: json['tag_name'] ?? 'Général',
    );
  }
}
class RecordingEntity {
  final String? id;
  final int? size;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? type;
  final String? downloadUrl;

  RecordingEntity({
    required this.id,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.downloadUrl,
  });
}

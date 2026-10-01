import '../../domain/entities/notifications_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // RLS limits the embedded notification_reads rows to the caller's own,
    // so "any row present" means this user has read it.
    final reads = json['notification_reads'] as List<dynamic>? ?? const [];
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: reads.isNotEmpty,
    );
  }
}
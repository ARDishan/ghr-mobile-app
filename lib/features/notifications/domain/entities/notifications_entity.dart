import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  /// e.g. PAYMENT_SCHEDULE, DUE_REMINDER_1, WELCOME_LETTER, ANNOUNCEMENT.
  final String kind;

  /// Optional link (e.g. the payment-schedule PDF on Google Drive).
  final String? linkUrl;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.kind = 'ANNOUNCEMENT',
    this.linkUrl,
  });

  bool get hasLink => linkUrl != null && linkUrl!.trim().isNotEmpty;

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        kind: kind,
        linkUrl: linkUrl,
      );

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead, kind, linkUrl];
}

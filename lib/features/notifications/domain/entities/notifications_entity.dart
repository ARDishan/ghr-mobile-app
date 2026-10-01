import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead];
}
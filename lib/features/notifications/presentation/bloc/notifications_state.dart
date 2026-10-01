import 'package:equatable/equatable.dart';
import '../../domain/entities/notifications_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> items;
  const NotificationsLoaded(this.items);

  int get unreadCount => items.where((i) => !i.isRead).length;

  @override
  List<Object?> get props => [items];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
  @override
  List<Object?> get props => [message];
}
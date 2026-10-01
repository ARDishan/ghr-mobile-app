import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notifications_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications {
  final NotificationsRepository repository;
  GetNotifications(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() =>
      repository.getNotifications();
}

class MarkNotificationsRead {
  final NotificationsRepository repository;
  MarkNotificationsRead(this.repository);

  Future<Either<Failure, void>> call(List<String> ids) =>
      repository.markAsRead(ids);
}
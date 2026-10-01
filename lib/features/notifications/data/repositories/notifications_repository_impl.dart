import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notifications_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      return Right(await remoteDataSource.getNotifications());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(List<String> ids) async {
    try {
      await remoteDataSource.markAsRead(ids);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
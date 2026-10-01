import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/unit_repository.dart';
import '../datasources/units_remote_data_source.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitsRemoteDataSource remoteDataSource;
  UnitRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<UnitEntity>>> getUnitsByProject(int projectBasicId) async {
    try {
      final units = await remoteDataSource.getUnitsByProject(projectBasicId);
      return Right(units);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
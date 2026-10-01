import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/my_unit_entity.dart';
import '../../domain/repositories/my_units_repository.dart';
import '../datasources/my_units_remote_data_source.dart';

class MyUnitsRepositoryImpl implements MyUnitsRepository {
  final MyUnitsRemoteDataSource remoteDataSource;
  MyUnitsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MyUnitEntity>>> getMyUnits() async {
    try {
      return Right(await remoteDataSource.getMyUnits());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
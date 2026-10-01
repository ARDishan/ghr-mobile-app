import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/unit_entity.dart';

abstract class UnitRepository {
  Future<Either<Failure, List<UnitEntity>>> getUnitsByProject(int projectBasicId);
}
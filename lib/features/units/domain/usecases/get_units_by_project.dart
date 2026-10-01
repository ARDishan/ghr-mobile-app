import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/unit_entity.dart';
import '../repositories/unit_repository.dart';

class GetUnitsByProject {
  final UnitRepository repository;
  GetUnitsByProject(this.repository);

  Future<Either<Failure, List<UnitEntity>>> call(int projectBasicId) {
    return repository.getUnitsByProject(projectBasicId);
  }
}
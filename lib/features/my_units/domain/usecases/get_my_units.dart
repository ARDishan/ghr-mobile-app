import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/my_unit_entity.dart';
import '../repositories/my_units_repository.dart';

class GetMyUnits {
  final MyUnitsRepository repository;
  GetMyUnits(this.repository);

  Future<Either<Failure, List<MyUnitEntity>>> call() => repository.getMyUnits();
}
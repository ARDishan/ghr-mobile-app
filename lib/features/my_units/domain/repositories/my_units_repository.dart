import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/my_unit_entity.dart';

abstract class MyUnitsRepository {
  Future<Either<Failure, List<MyUnitEntity>>> getMyUnits();
}
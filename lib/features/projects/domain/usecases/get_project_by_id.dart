import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/projects_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectById {
  final ProjectRepository repository;
  GetProjectById(this.repository);

  Future<Either<Failure, ProjectEntity>> call(String id) {
    return repository.getProjectById(id);
  }
}
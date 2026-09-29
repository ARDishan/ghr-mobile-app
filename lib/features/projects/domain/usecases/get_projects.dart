import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/projects_entity.dart';
import '../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;
  GetProjects(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call() {
    return repository.getProjects();
  }
}
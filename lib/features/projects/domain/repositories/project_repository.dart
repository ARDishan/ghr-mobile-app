import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/projects_entity.dart';

abstract class ProjectRepository {
  /// Active projects only (RLS already filters this server-side too).
  Future<Either<Failure, List<ProjectEntity>>> getProjects();

  Future<Either<Failure, ProjectEntity>> getProjectById(String id);
}
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/projects_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/projects_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectsRemoteDataSource remoteDataSource;
  ProjectRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectById(String id) async {
    try {
      final project = await remoteDataSource.getProjectById(id);
      return Right(project);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
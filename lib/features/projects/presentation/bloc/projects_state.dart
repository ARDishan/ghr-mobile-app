import 'package:equatable/equatable.dart';
import '../../domain/entities/projects_entity.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;
  const ProjectsLoaded(this.projects);
  @override
  List<Object?> get props => [projects];
}

class ProjectDetailLoading extends ProjectsState {}

class ProjectDetailLoaded extends ProjectsState {
  final ProjectEntity project;
  const ProjectDetailLoaded(this.project);
  @override
  List<Object?> get props => [project];
}

class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);
  @override
  List<Object?> get props => [message];
}
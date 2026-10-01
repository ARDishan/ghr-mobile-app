import 'package:equatable/equatable.dart';
import '../../domain/entities/projects_entity.dart';

abstract class ProjectDetailState extends Equatable {
  const ProjectDetailState();
  @override
  List<Object?> get props => [];
}

class ProjectDetailInitial extends ProjectDetailState {}

class ProjectDetailLoading extends ProjectDetailState {}

class ProjectDetailLoaded extends ProjectDetailState {
  final ProjectEntity project;
  const ProjectDetailLoaded(this.project);
  @override
  List<Object?> get props => [project];
}

class ProjectDetailError extends ProjectDetailState {
  final String message;
  const ProjectDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
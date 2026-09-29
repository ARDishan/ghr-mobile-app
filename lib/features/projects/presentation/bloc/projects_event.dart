import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();
  @override
  List<Object?> get props => [];
}

class ProjectsLoadRequested extends ProjectsEvent {
  const ProjectsLoadRequested();
}

class ProjectDetailLoadRequested extends ProjectsEvent {
  final String id;
  const ProjectDetailLoadRequested(this.id);
  @override
  List<Object?> get props => [id];
}
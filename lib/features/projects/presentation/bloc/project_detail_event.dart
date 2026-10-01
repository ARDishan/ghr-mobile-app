import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();
  @override
  List<Object?> get props => [];
}

class ProjectDetailLoadRequested extends ProjectDetailEvent {
  final String id;
  const ProjectDetailLoadRequested(this.id);
  @override
  List<Object?> get props => [id];
}
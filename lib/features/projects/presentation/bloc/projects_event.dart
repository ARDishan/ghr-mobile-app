import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();
  @override
  List<Object?> get props => [];
}

class ProjectsLoadRequested extends ProjectsEvent {
  /// Completed when loading finishes, so pull-to-refresh can await it.
  final Completer<void>? completer;
  const ProjectsLoadRequested({this.completer});
}

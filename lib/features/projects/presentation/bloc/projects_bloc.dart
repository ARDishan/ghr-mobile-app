import 'package:flutter_bloc/flutter_bloc.dart';
import 'projects_event.dart';
import 'projects_state.dart';

// TODO: implement.
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(ProjectsInitial());
}

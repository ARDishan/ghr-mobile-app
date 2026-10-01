import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_projects.dart';
import 'projects_event.dart';
import 'projects_state.dart';

/// App-wide list of projects (Home, Projects, Saved). Single-project loading
/// lives in ProjectDetailBloc so it can never overwrite this list's state.
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjects getProjects;

  ProjectsBloc({required this.getProjects}) : super(ProjectsInitial()) {
    on<ProjectsLoadRequested>(_onLoadProjects);
  }

  Future<void> _onLoadProjects(
    ProjectsLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    final result = await getProjects();
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }
}
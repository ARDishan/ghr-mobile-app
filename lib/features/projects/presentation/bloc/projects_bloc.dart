import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_project_by_id.dart';
import '../../domain/usecases/get_projects.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjects getProjects;
  final GetProjectById getProjectById;

  ProjectsBloc({
    required this.getProjects,
    required this.getProjectById,
  }) : super(ProjectsInitial()) {
    on<ProjectsLoadRequested>(_onLoadProjects);
    on<ProjectDetailLoadRequested>(_onLoadProjectDetail);
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

  Future<void> _onLoadProjectDetail(
    ProjectDetailLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectDetailLoading());
    final result = await getProjectById(event.id);
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (project) => emit(ProjectDetailLoaded(project)),
    );
  }
}
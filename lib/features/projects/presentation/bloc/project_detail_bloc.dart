import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_project_by_id.dart';
import 'project_detail_event.dart';
import 'project_detail_state.dart';

/// One instance per project-detail screen (provided in the route).
class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final GetProjectById getProjectById;

  ProjectDetailBloc({required this.getProjectById})
      : super(ProjectDetailInitial()) {
    on<ProjectDetailLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    ProjectDetailLoadRequested event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(ProjectDetailLoading());
    final result = await getProjectById(event.id);
    result.fold(
      (failure) => emit(ProjectDetailError(failure.message)),
      (project) => emit(ProjectDetailLoaded(project)),
    );
  }
}
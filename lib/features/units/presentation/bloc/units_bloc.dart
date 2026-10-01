import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_units_by_project.dart';
import 'units_event.dart';
import 'units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final GetUnitsByProject getUnitsByProject;

  UnitsBloc({required this.getUnitsByProject}) : super(UnitsInitial()) {
    on<UnitsLoadRequested>(_onLoadUnits);
  }

  Future<void> _onLoadUnits(
    UnitsLoadRequested event,
    Emitter<UnitsState> emit,
  ) async {
    emit(UnitsLoading());
    final result = await getUnitsByProject(event.projectBasicId);
    result.fold(
      (failure) => emit(UnitsError(failure.message)),
      (units) => emit(UnitsLoaded(units)),
    );
  }
}
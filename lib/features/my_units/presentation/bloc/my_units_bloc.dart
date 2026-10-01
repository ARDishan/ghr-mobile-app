import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_units.dart';
import 'my_units_event.dart';
import 'my_units_state.dart';

class MyUnitsBloc extends Bloc<MyUnitsEvent, MyUnitsState> {
  final GetMyUnits getMyUnits;

  MyUnitsBloc({required this.getMyUnits}) : super(MyUnitsInitial()) {
    on<MyUnitsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    MyUnitsLoadRequested event,
    Emitter<MyUnitsState> emit,
  ) async {
    // On pull-to-refresh keep the current list on screen instead of flashing a loader.
    if (state is! MyUnitsLoaded) emit(MyUnitsLoading());
    final result = await getMyUnits();
    result.fold(
      (failure) => emit(MyUnitsError(failure.message)),
      (units) => emit(MyUnitsLoaded(units)),
    );
    event.completer?.complete();
  }
}
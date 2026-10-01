import 'package:equatable/equatable.dart';
import '../../domain/entities/my_unit_entity.dart';

abstract class MyUnitsState extends Equatable {
  const MyUnitsState();
  @override
  List<Object?> get props => [];
}

class MyUnitsInitial extends MyUnitsState {}

class MyUnitsLoading extends MyUnitsState {}

class MyUnitsLoaded extends MyUnitsState {
  final List<MyUnitEntity> units;
  const MyUnitsLoaded(this.units);

  double get totalOutstanding => units.fold(0.0, (s, u) => s + u.outstanding);
  double get totalOverdue => units.fold(0.0, (s, u) => s + u.overdue);

  @override
  List<Object?> get props => [units];
}

class MyUnitsError extends MyUnitsState {
  final String message;
  const MyUnitsError(this.message);
  @override
  List<Object?> get props => [message];
}
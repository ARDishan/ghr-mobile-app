import 'package:equatable/equatable.dart';
import '../../domain/entities/unit_entity.dart';

abstract class UnitsState extends Equatable {
  const UnitsState();
  @override
  List<Object?> get props => [];
}

class UnitsInitial extends UnitsState {}

class UnitsLoading extends UnitsState {}

class UnitsLoaded extends UnitsState {
  final List<UnitEntity> units;
  const UnitsLoaded(this.units);
  @override
  List<Object?> get props => [units];
}

class UnitsError extends UnitsState {
  final String message;
  const UnitsError(this.message);
  @override
  List<Object?> get props => [message];
}
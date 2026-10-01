import 'package:equatable/equatable.dart';

abstract class UnitsEvent extends Equatable {
  const UnitsEvent();
  @override
  List<Object?> get props => [];
}

class UnitsLoadRequested extends UnitsEvent {
  final int projectBasicId;
  const UnitsLoadRequested(this.projectBasicId);
  @override
  List<Object?> get props => [projectBasicId];
}
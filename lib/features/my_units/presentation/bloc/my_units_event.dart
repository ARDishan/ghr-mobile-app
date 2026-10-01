import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class MyUnitsEvent extends Equatable {
  const MyUnitsEvent();
  @override
  List<Object?> get props => [];
}

class MyUnitsLoadRequested extends MyUnitsEvent {
  /// Completed when loading finishes; lets RefreshIndicator await the result.
  final Completer<void>? completer;
  const MyUnitsLoadRequested({this.completer});
}
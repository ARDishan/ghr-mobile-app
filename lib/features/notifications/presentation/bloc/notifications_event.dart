import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsLoadRequested extends NotificationsEvent {
  final Completer<void>? completer;
  const NotificationsLoadRequested({this.completer});
}

class NotificationsMarkReadRequested extends NotificationsEvent {
  final List<String> ids;
  const NotificationsMarkReadRequested(this.ids);
  @override
  List<Object?> get props => [ids];
}

class NotificationsMarkAllReadRequested extends NotificationsEvent {
  const NotificationsMarkAllReadRequested();
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/notifications_usecases.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications getNotifications;
  final MarkNotificationsRead markNotificationsRead;

  NotificationsBloc({
    required this.getNotifications,
    required this.markNotificationsRead,
  }) : super(NotificationsInitial()) {
    on<NotificationsLoadRequested>(_onLoad);
    on<NotificationsMarkReadRequested>(_onMarkRead);
    on<NotificationsMarkAllReadRequested>(_onMarkAllRead);
  }

  Future<void> _onLoad(
    NotificationsLoadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsLoaded) emit(NotificationsLoading());
    final result = await getNotifications();
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (items) => emit(NotificationsLoaded(items)),
    );
    event.completer?.complete();
  }

  Future<void> _onMarkRead(
    NotificationsMarkReadRequested event,
    Emitter<NotificationsState> emit,
  ) =>
      _markRead(event.ids, emit);

  Future<void> _onMarkAllRead(
    NotificationsMarkAllReadRequested event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is! NotificationsLoaded) return Future.value();
    return _markRead(
      current.items.where((i) => !i.isRead).map((i) => i.id).toList(),
      emit,
    );
  }

  Future<void> _markRead(List<String> ids, Emitter<NotificationsState> emit) async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    final toMark = ids
        .where((id) => current.items.any((i) => i.id == id && !i.isRead))
        .toList();
    if (toMark.isEmpty) return;

    // Optimistic update so the badge clears immediately.
    emit(NotificationsLoaded(
      current.items
          .map((i) => toMark.contains(i.id) ? i.copyWith(isRead: true) : i)
          .toList(),
    ));

    final result = await markNotificationsRead(toMark);
    // If saving failed, restore the previous state so the badge stays honest.
    result.fold((_) => emit(current), (_) {});
  }
}
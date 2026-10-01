import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bookmarks_local_data_source.dart';

class BookmarksState extends Equatable {
  final Set<String> ids;
  const BookmarksState(this.ids);
  bool contains(String id) => ids.contains(id);
  @override
  List<Object?> get props => [ids];
}

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksLocalDataSource _local;

  BookmarksCubit(this._local) : super(BookmarksState(_local.read()));

  Future<void> toggle(String projectId) async {
    final next = {...state.ids};
    if (!next.add(projectId)) next.remove(projectId);
    emit(BookmarksState(next));
    await _local.write(next);
  }
}
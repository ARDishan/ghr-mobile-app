import 'package:shared_preferences/shared_preferences.dart';

/// Saved project ids, stored on this device only.
class BookmarksLocalDataSource {
  static const _key = 'bookmarked_project_ids';
  final SharedPreferences prefs;
  BookmarksLocalDataSource(this.prefs);

  Set<String> read() => (prefs.getStringList(_key) ?? const <String>[]).toSet();

  Future<void> write(Set<String> ids) => prefs.setStringList(_key, ids.toList());
}
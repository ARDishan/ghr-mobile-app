import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/entities/projects_entity.dart';

String _norm(String? v) => (v ?? '').trim().toLowerCase();

/// Search + filters for the project list. All matching is case-insensitive.
class ProjectFilter extends Equatable {
  final String query;
  final String? city;
  final String? type;
  final String? branchPrefix;

  const ProjectFilter({this.query = '', this.city, this.type, this.branchPrefix});

  int get activeCount =>
      (city != null ? 1 : 0) + (type != null ? 1 : 0) + (branchPrefix != null ? 1 : 0);

  bool get isActive => activeCount > 0 || query.trim().isNotEmpty;

  ProjectFilter withQuery(String v) =>
      ProjectFilter(query: v, city: city, type: type, branchPrefix: branchPrefix);
  ProjectFilter withCity(String? v) =>
      ProjectFilter(query: query, city: v, type: type, branchPrefix: branchPrefix);
  ProjectFilter withType(String? v) =>
      ProjectFilter(query: query, city: city, type: v, branchPrefix: branchPrefix);
  ProjectFilter withBranch(String? v) =>
      ProjectFilter(query: query, city: city, type: type, branchPrefix: v);

  bool matches(ProjectEntity p) {
    if (city != null && _norm(p.city) != _norm(city)) return false;
    if (type != null && _norm(p.type) != _norm(type)) return false;
    if (branchPrefix != null && _norm(p.branchPrefix) != _norm(branchPrefix)) return false;
    final q = _norm(query);
    if (q.isNotEmpty) {
      final haystack =
          [p.name, p.city, p.type, p.address, p.code].map(_norm).join(' ');
      if (!haystack.contains(q)) return false;
    }
    return true;
  }

  List<ProjectEntity> apply(List<ProjectEntity> projects) =>
      projects.where(matches).toList();

  @override
  List<Object?> get props => [query, city, type, branchPrefix];
}

class OptionCount {
  final String label;
  final int count;
  const OptionCount(this.label, this.count);
}

class BranchOption {
  final String prefix;
  final String label;
  const BranchOption(this.prefix, this.label);
}

/// Values for Top Locations / Property Types / filters, taken from real data.
extension ProjectInsights on List<ProjectEntity> {
  List<OptionCount> get cityCounts => _count((p) => p.city);
  List<OptionCount> get typeCounts => _count((p) => p.type);

  List<OptionCount> _count(String? Function(ProjectEntity) pick) {
    final counts = <String, int>{};
    final labels = <String, String>{};
    for (final p in this) {
      final raw = pick(p);
      if (raw == null || raw.trim().isEmpty || raw.trim().toUpperCase() == 'NA') continue;
      final key = _norm(raw);
      counts[key] = (counts[key] ?? 0) + 1;
      labels.putIfAbsent(key, () => toTitleCase(raw));
    }
    final list = counts.entries
        .map((e) => OptionCount(labels[e.key]!, e.value))
        .toList()
      ..sort((a, b) {
        final c = b.count.compareTo(a.count);
        return c != 0 ? c : a.label.compareTo(b.label);
      });
    return list;
  }

  /// Distinct branches present in the data, main company first.
  List<BranchOption> get branches {
    final seen = <String, String>{};
    for (final p in this) {
      final prefix = p.branchPrefix;
      if (prefix == null || prefix.trim().isEmpty) continue;
      seen.putIfAbsent(prefix.toUpperCase(), () => p.branchLabel ?? prefix);
    }
    final list = seen.entries.map((e) => BranchOption(e.key, e.value)).toList()
      ..sort((a, b) {
        if (a.prefix == AppConstants.mainBranchPrefix) return -1;
        if (b.prefix == AppConstants.mainBranchPrefix) return 1;
        return a.label.compareTo(b.label);
      });
    return list;
  }

  /// Ongoing projects first, then completed (used for the Home carousel).
  List<ProjectEntity> get featured {
    final ongoing = where((p) => !p.isCompleted).toList();
    final done = where((p) => p.isCompleted).toList();
    return [...ongoing, ...done];
  }
}

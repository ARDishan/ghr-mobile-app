import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/company_stats_repository.dart';

enum AboutStatus { loading, loaded }

class AboutState extends Equatable {
  final AboutStatus status;
  final CompanyStats? stats;
  final List<CompanyBranch> branches;

  const AboutState({
    this.status = AboutStatus.loading,
    this.stats,
    this.branches = const [],
  });

  @override
  List<Object?> get props => [
        status,
        stats?.projectsTotal,
        stats?.projectsCompleted,
        stats?.projectsOngoing,
        stats?.unitsTotal,
        branches.map((b) => b.prefix).toList(),
      ];
}

class AboutCubit extends Cubit<AboutState> {
  final CompanyStatsRepository repository;
  AboutCubit(this.repository) : super(const AboutState());

  /// Stats and branches load independently: the page is still useful if either
  /// one fails (that block is simply hidden).
  Future<void> load() async {
    emit(const AboutState());
    final results = await Future.wait([
      repository.getStats(),
      repository.getBranches(),
    ]);

    final stats = (results[0] as dynamic).fold((_) => null, (v) => v) as CompanyStats?;
    final branches = (results[1] as dynamic)
        .fold((_) => <CompanyBranch>[], (v) => v) as List<CompanyBranch>;

    emit(AboutState(
      status: AboutStatus.loaded,
      stats: stats,
      branches: branches,
    ));
  }
}

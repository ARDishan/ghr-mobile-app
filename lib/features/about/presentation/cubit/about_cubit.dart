import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/company_stats_repository.dart';

enum AboutStatus { loading, loaded, failed }

class AboutState extends Equatable {
  final AboutStatus status;
  final CompanyStats? stats;
  const AboutState({this.status = AboutStatus.loading, this.stats});

  @override
  List<Object?> get props => [status, stats?.projectsTotal, stats?.unitsTotal,
      stats?.projectsCompleted, stats?.projectsOngoing];
}

class AboutCubit extends Cubit<AboutState> {
  final CompanyStatsRepository repository;
  AboutCubit(this.repository) : super(const AboutState());

  Future<void> load() async {
    emit(const AboutState());
    final result = await repository.getStats();
    result.fold(
      // The About page is still useful without stats, so failure just hides them.
      (_) => emit(const AboutState(status: AboutStatus.failed)),
      (stats) => emit(AboutState(status: AboutStatus.loaded, stats: stats)),
    );
  }
}
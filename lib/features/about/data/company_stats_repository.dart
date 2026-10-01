import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../core/errors/failures.dart';

/// Counts computed from Supabase data (projects/units), not marketing copy.
class CompanyStats {
  final int projectsTotal;
  final int projectsCompleted;
  final int projectsOngoing;
  final int unitsTotal;

  const CompanyStats({
    required this.projectsTotal,
    required this.projectsCompleted,
    required this.projectsOngoing,
    required this.unitsTotal,
  });

  factory CompanyStats.fromJson(Map<String, dynamic> json) => CompanyStats(
        projectsTotal: (json['projects_total'] as num?)?.toInt() ?? 0,
        projectsCompleted: (json['projects_completed'] as num?)?.toInt() ?? 0,
        projectsOngoing: (json['projects_ongoing'] as num?)?.toInt() ?? 0,
        unitsTotal: (json['units_total'] as num?)?.toInt() ?? 0,
      );
}

class CompanyStatsRepository {
  final supa.SupabaseClient client;
  CompanyStatsRepository(this.client);

  Future<Either<Failure, CompanyStats>> getStats() async {
    try {
      final result = await client.rpc('get_company_stats');
      final row = result is List ? result.first : result;
      return Right(CompanyStats.fromJson(row as Map<String, dynamic>));
    } on supa.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
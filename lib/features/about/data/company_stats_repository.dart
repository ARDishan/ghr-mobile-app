import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../core/constants/app_constants.dart';
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

/// A company/branch from the ERP's branchmast (GHR, CED, ...).
class CompanyBranch {
  final String prefix;
  final String name;
  final String? address;
  final String? email;
  final String? mobile;

  const CompanyBranch({
    required this.prefix,
    required this.name,
    this.address,
    this.email,
    this.mobile,
  });

  bool get isMain => prefix.toUpperCase() == AppConstants.mainBranchPrefix;

  factory CompanyBranch.fromJson(Map<String, dynamic> json) => CompanyBranch(
        prefix: (json['branchprefix'] as String?) ?? '',
        name: json['branchname'] as String,
        address: json['address'] as String?,
        email: json['email'] as String?,
        mobile: json['mobile'] as String?,
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

  /// Active branches, main company (GHR) first.
  Future<Either<Failure, List<CompanyBranch>>> getBranches() async {
    try {
      final rows = await client
          .from('branches')
          .select('branchprefix, branchname, address, email, mobile')
          .eq('is_active', true);
      final list = (rows as List)
          .map((r) => CompanyBranch.fromJson(r as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          if (a.isMain != b.isMain) return a.isMain ? -1 : 1;
          return a.name.compareTo(b.name);
        });
      return Right(list);
    } on supa.PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

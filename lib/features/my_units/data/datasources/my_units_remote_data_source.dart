import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/my_unit_model.dart';

abstract class MyUnitsRemoteDataSource {
  Future<List<MyUnitModel>> getMyUnits();
}

class MyUnitsRemoteDataSourceImpl implements MyUnitsRemoteDataSource {
  final supa.SupabaseClient client;
  MyUnitsRemoteDataSourceImpl(this.client);

  @override
  Future<List<MyUnitModel>> getMyUnits() async {
    try {
      // RLS on cso_core limits this to the caller's own transactions.
      final rows = await client.rpc(
        'get_my_outstanding_summary',
        params: {'p_grace_days': AppConstants.overdueGraceDays},
      );
      return (rows as List)
          .map((r) => MyUnitModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
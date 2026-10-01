import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/exceptions.dart';
import '../models/unit_model.dart';

abstract class UnitsRemoteDataSource {
  Future<List<UnitModel>> getUnitsByProject(int projectBasicId);
}

class UnitsRemoteDataSourceImpl implements UnitsRemoteDataSource {
  final supa.SupabaseClient client;
  UnitsRemoteDataSourceImpl(this.client);

  @override
  Future<List<UnitModel>> getUnitsByProject(int projectBasicId) async {
    try {
      final rows = await client
          .from('units')
          .select()
          .eq('project_basicid', projectBasicId)
          // Text sort on `floor`/`unit` — not numeric-aware (e.g. "10TH
          // FLOOR" sorts before "2ND FLOOR"). Fine for now; revisit if
          // floor/unit ordering needs to be numeric.
          .order('floor')
          .order('unit');
      return (rows as List)
          .map((row) => UnitModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
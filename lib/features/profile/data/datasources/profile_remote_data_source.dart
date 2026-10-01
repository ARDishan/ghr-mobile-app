import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final supa.SupabaseClient client;
  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<ProfileModel> getProfile() async {
    try {
      // RLS (customers_select_own_by_phone) returns only the caller's own row,
      // whatever format the stored mobile number is in.
      final row = await client.from('customers').select().limit(1).maybeSingle();
      if (row == null) {
        throw ServerException('We could not find your customer profile.');
      }
      return ProfileModel.fromJson(row);
    } on ServerException {
      rethrow;
    } on supa.PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
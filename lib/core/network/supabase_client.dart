import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

/// Thin wrapper around Supabase initialization/access.
/// Call [SupabaseClientService.init] once in main() before runApp,
/// after dotenv has been loaded.
class SupabaseClientService {
  SupabaseClientService._();

  static Future<void> init() async {
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads Supabase config from the .env file (see .env.example).
/// TODO: throw a clear startup error if either value is missing, rather
/// than silently running with an empty string.
class ApiConstants {
  ApiConstants._();

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
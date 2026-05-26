import 'package:flutter_dotenv/flutter_dotenv.dart';

class StockFlowEnv {
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing SUPABASE_URL in .env');
    }
    if (value.contains('://db.') || value.contains('.supabase.co:5432')) {
      throw StateError(
        'SUPABASE_URL is set to the database host. Use the project API URL '
        'instead (https://<project-ref>.supabase.co).',
      );
    }
    return value;
  }

  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing SUPABASE_ANON_KEY in .env');
    }
    return value;
  }
}

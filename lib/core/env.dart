import 'package:flutter_dotenv/flutter_dotenv.dart';

class MakhzanFlowEnv {
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

  static String get sentryDsn {
    final value = dotenv.env['SENTRY_DSN']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing SENTRY_DSN in .env');
    }
    return value;
  }

  static String get googleWebClientId {
    final value = dotenv.env['GOOGLE_WEB_CLIENT_ID']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing GOOGLE_WEB_CLIENT_ID in .env');
    }
    return value;
  }
}

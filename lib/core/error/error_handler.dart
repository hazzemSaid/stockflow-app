import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import '../constants/app_strings.dart';
import 'exceptions.dart';

String handleError(Object error, StackTrace stackTrace) {
  return switch (error) {
    ServerException e => e.message,
    AuthException e => e.message,
    PostgrestException e => e.message,
    Exception e => e.toString(),
    _ => AppStrings.unexpectedError,
  };
}

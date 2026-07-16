import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:makhzanflow/core/env.dart';

void main() {
  group('Sentry only in production', () {
    test('kReleaseMode is false during tests (debug mode)', () {
      expect(kReleaseMode, isFalse);
    });

    test('sentryDsn reads DSN from env', () {
      dotenv.testLoad(
        fileInput: 'SENTRY_DSN=https://key@o123.ingest.us.sentry.io/project',
      );

      expect(MakhzanFlowEnv.sentryDsn, startsWith('https://'));
      expect(MakhzanFlowEnv.sentryDsn,
          'https://key@o123.ingest.us.sentry.io/project');
    });

    test('sentryDsn throws when SENTRY_DSN is missing', () {
      dotenv.testLoad(fileInput: 'OTHER_VAR=value');
      expect(() => MakhzanFlowEnv.sentryDsn, throwsStateError);
    });
  });
}

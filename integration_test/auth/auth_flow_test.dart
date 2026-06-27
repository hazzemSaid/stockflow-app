import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/auth/presentation/pages/login_screen.dart';
import 'package:stockflow/features/auth/presentation/pages/register_screen.dart';
import 'package:stockflow/features/auth/presentation/pages/splash_screen.dart';
import 'package:stockflow/features/auth/presentation/pages/welcome_screen.dart';
import '../shared/test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Splash Screen', () {
    testWidgets('renders app name and loading indicator', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const SplashScreen()));
      await tester.pump();

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.appNameArabic), findsOneWidget);
      expect(find.text(AppStrings.appSubtitle), findsOneWidget);
      expect(find.text(AppStrings.loading), findsOneWidget);
      expect(find.text(AppStrings.appVersion), findsOneWidget);
    });
  });

  group('Login Screen', () {
    testWidgets('renders all login form elements', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const LoginScreen()));
      await tester.pump();

      expect(find.text(AppStrings.welcomeBack), findsOneWidget);
      expect(find.text(AppStrings.loginToContinue), findsOneWidget);
      expect(find.text(AppStrings.emailLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.rememberMe), findsOneWidget);
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);
      expect(find.text(AppStrings.loginButton), findsOneWidget);
      expect(find.text(AppStrings.dontHaveAccount), findsOneWidget);
      expect(find.text(AppStrings.registerNow), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const LoginScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.loginButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const LoginScreen()));
      await tester.pump();

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.tap(find.text(AppStrings.loginButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emailInvalid), findsOneWidget);
    });

    testWidgets('shows password min length error', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const LoginScreen()));
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'test@example.com');
      await tester.enterText(fields.last, '123');
      await tester.tap(find.text(AppStrings.loginButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
    });
  });

  group('Register Screen', () {
    testWidgets('renders all registration form elements', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const RegisterScreen()));
      await tester.pump();

      expect(find.text(AppStrings.registerWelcome), findsOneWidget);
      expect(find.text(AppStrings.registerToContinue), findsOneWidget);
      expect(find.text(AppStrings.nameLabel), findsOneWidget);
      expect(find.text(AppStrings.emailLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.confirmPasswordLabel), findsOneWidget);
      expect(find.text(AppStrings.registerButton), findsOneWidget);
      expect(find.text(AppStrings.alreadyHaveAccount), findsOneWidget);
      expect(find.text(AppStrings.loginNow), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const RegisterScreen()));
      await tester.pump();

      await tester.tap(find.text(AppStrings.registerButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.nameRequired), findsOneWidget);
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    });

    testWidgets('shows password mismatch error', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const RegisterScreen()));
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'أحمد محمد');
      await tester.enterText(fields.at(1), 'test@example.com');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'different-password');
      await tester.tap(find.text(AppStrings.registerButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordMismatch), findsOneWidget);
    });
  });

  group('Welcome Screen', () {
    testWidgets('renders welcome screen with create and join buttons', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const WelcomeScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(hasCompanies: false),
      ));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.createBusiness), findsOneWidget);
      expect(find.text(AppStrings.joinBusiness), findsOneWidget);
      expect(find.text(AppStrings.signOut), findsOneWidget);
    });
  });

  group('Auth Form Field Typing', () {
    testWidgets('can type into login email and password fields', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const LoginScreen()));
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, 'user@stockflow.eg');
      await tester.enterText(fields.last, 'mypassword');
    });

    testWidgets('can type into register form fields', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(child: const RegisterScreen()));
      await tester.pump();

      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(4));

      await tester.enterText(fields.at(0), 'أحمد محمد');
      await tester.enterText(fields.at(1), 'ahmed@stockflow.eg');
      await tester.enterText(fields.at(2), 'securepass123');
      await tester.enterText(fields.at(3), 'securepass123');

      await tester.tap(find.text(AppStrings.registerButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.nameRequired), findsNothing);
      expect(find.text(AppStrings.emailRequired), findsNothing);
      expect(find.text(AppStrings.passwordRequired), findsNothing);
    });
  });
}

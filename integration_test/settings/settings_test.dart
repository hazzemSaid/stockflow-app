import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/settings/presentation/pages/settings_screen.dart';
import '../shared/test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Screen', () {
    testWidgets('renders settings screen with all tiles', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const SettingsScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(selected: true),
      ));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.companySettings), findsOneWidget);
      expect(find.text(AppStrings.teamMembers), findsOneWidget);
      expect(find.text(AppStrings.signOut), findsOneWidget);
    });

    testWidgets('renders company switcher', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const SettingsScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(selected: true),
      ));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.switchCompany), findsOneWidget);
    });

    testWidgets('sign out button is tappable', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const SettingsScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(selected: true),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.signOut));
      await tester.pumpAndSettle();
    });
  });
}

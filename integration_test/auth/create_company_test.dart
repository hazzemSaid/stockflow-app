import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/auth/presentation/pages/create_company_screen.dart';
import '../shared/test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create Company Screen', () {
    testWidgets('renders create company form with all fields', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.createBusiness), findsOneWidget);
      expect(find.text(AppStrings.createBusinessSubtitle), findsOneWidget);
      expect(find.text(AppStrings.businessNameLabel), findsOneWidget);
      expect(find.text(AppStrings.businessTypeLabel), findsOneWidget);
      expect(find.text(AppStrings.phone), findsOneWidget);
      expect(find.text(AppStrings.address), findsOneWidget);
      expect(find.text(AppStrings.cancelButton), findsOneWidget);
      expect(find.text(AppStrings.createBusinessButton), findsOneWidget);
    });

    testWidgets('renders business type chips', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.businessTypeWholesale), findsOneWidget);
      expect(find.text(AppStrings.businessTypeRetail), findsOneWidget);
      expect(find.text(AppStrings.businessTypePharmacy), findsOneWidget);
      expect(find.text(AppStrings.businessTypeSupermarket), findsOneWidget);
      expect(find.text(AppStrings.businessTypeRestaurant), findsOneWidget);
      expect(find.text(AppStrings.businessTypeOther), findsOneWidget);
    });

    testWidgets('renders logo picker hint text', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      expect(find.text(AppStrings.logoPickerHint), findsWidgets);
    });

    testWidgets('shows validation error on empty submit', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.createBusinessButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.businessNameRequired), findsOneWidget);
    });

    testWidgets('can fill in business name field', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'متجر اختبار');
    });

    testWidgets('can select a business type chip', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.businessTypeRestaurant));
      await tester.pumpAndSettle();
    });

    testWidgets('cancel button is tappable', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.cancelButton));
      await tester.pumpAndSettle();
    });

    testWidgets('can fill in all form fields', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithProviders(
        child: const CreateCompanyScreen(),
        authCubit: TestSetup.createMockAuthCubit(),
        companyCubit: TestSetup.createMockCompanyCubit(),
      ));

      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'مخزن الجملة');
      await tester.enterText(fields.at(1), '01234567890');
      await tester.enterText(fields.at(2), '١٥ شارع التحرير، القاهرة');

      await tester.tap(find.text(AppStrings.businessTypeRetail));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.createBusinessButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.businessNameRequired), findsNothing);
    });
  });
}

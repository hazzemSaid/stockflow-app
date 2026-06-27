import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:stockflow/features/invoice/presentation/cubit/invoices/invoices_cubit.dart';
import 'package:stockflow/features/invoice/presentation/pages/invoices_screen.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoices_empty_state.dart';
import '../shared/test_setup.dart';

class MockInvoicesCubit extends Cubit<InvoicesState> implements InvoicesCubit {
  MockInvoicesCubit(super.state);

  @override
  Future<void> loadInvoices(String companyId) async {}

  @override
  Future<void> refresh(String companyId) async {}

  @override
  void setFilter({
    required String companyId,
    InvoiceStatus? statusFilter,
    String? customerId,
  }) {}

  @override
  void clearFilters(String companyId) {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Invoices Screen - States', () {
    testWidgets('shows loading indicator in initial state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<InvoicesCubit>(
          create: (_) => MockInvoicesCubit(
            const InvoicesState(status: InvoicesStatus.loading),
          ),
          child: const InvoicesScreen(),
        ),
      ));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no invoices', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<InvoicesCubit>(
          create: (_) => MockInvoicesCubit(
            const InvoicesState(status: InvoicesStatus.empty),
          ),
          child: const InvoicesScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text(AppStrings.emptyInvoices), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<InvoicesCubit>(
          create: (_) => MockInvoicesCubit(
            const InvoicesState(
              status: InvoicesStatus.error,
              failure: ServerFailure('فشل تحميل الفواتير'),
            ),
          ),
          child: const InvoicesScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text('فشل تحميل الفواتير'), findsOneWidget);
    });
  });

  group('Invoices Screen - Filters', () {
    testWidgets('renders filter chips', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<InvoicesCubit>(
          create: (_) => MockInvoicesCubit(
            const InvoicesState(status: InvoicesStatus.loading),
          ),
          child: const InvoicesScreen(),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.customerAllFilter), findsOneWidget);
      expect(find.text(AppStrings.customerPaidFilter), findsOneWidget);
      expect(find.text(AppStrings.customerPartialFilter), findsOneWidget);
      expect(find.text(AppStrings.customerDeferredFilter), findsOneWidget);
    });

    testWidgets('renders invoice screen title in AppBar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<InvoicesCubit>(
          create: (_) => MockInvoicesCubit(
            const InvoicesState(status: InvoicesStatus.loading),
          ),
          child: const InvoicesScreen(),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.navInvoices), findsOneWidget);
    });
  });

  group('Invoices Empty State', () {
    testWidgets('renders empty state with filter message', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: InvoicesEmptyState(hasFilter: false),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.emptyInvoices), findsOneWidget);
    });

    testWidgets('renders empty state without filter message', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: InvoicesEmptyState(hasFilter: true),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.emptyInvoices), findsOneWidget);
    });
  });
}

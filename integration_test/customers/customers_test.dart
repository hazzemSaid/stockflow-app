import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/customers/presentation/cubit/customers/customers_cubit.dart';
import 'package:stockflow/features/customers/presentation/pages/customers_screen.dart';
import 'package:stockflow/features/customers/presentation/widgets/customer_list_header.dart';
import 'package:stockflow/features/customers/presentation/widgets/customer_search_bar.dart';
import 'package:stockflow/features/customers/presentation/widgets/customer_filter_chips.dart';
import '../shared/test_setup.dart';

class MockCustomersCubit extends Cubit<CustomersState> implements CustomersCubit {
  MockCustomersCubit(super.state);

  @override
  Future<void> loadCustomers(String companyId) async {}

  @override
  Future<void> loadMore(String companyId) async {}

  @override
  Future<void> refresh(String companyId) async {}

  @override
  void updateSearchQuery(String query, String companyId) {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Customers Screen - States', () {
    testWidgets('shows loading indicator in initial state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CustomersCubit>(
          create: (_) => MockCustomersCubit(
            const CustomersState(status: CustomersStatus.loading),
          ),
          child: const CustomersScreen(),
        ),
      ));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message when no customers', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CustomersCubit>(
          create: (_) => MockCustomersCubit(
            const CustomersState(status: CustomersStatus.empty),
          ),
          child: const CustomersScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text(AppStrings.emptyCustomers), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<CustomersCubit>(
          create: (_) => MockCustomersCubit(
            const CustomersState(
              status: CustomersStatus.error,
              failure: ServerFailure('خطأ في التحميل'),
            ),
          ),
          child: const CustomersScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text('خطأ في التحميل'), findsOneWidget);
    });
  });

  group('Customer List Header', () {
    testWidgets('renders header with title', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: CustomerListHeader(
              totalCount: 25,
              totalDebt: 15000.0,
            ),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.customersTitle), findsOneWidget);
    });
  });

  group('Customer Search Bar', () {
    testWidgets('renders search bar with add button', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: CustomerSearchBar(
              controller: TextEditingController(),
              onChanged: (_) {},
              onClear: () {},
              onAdd: () {},
            ),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.customersSearchHint), findsOneWidget);
    });
  });

  group('Customer Filter Chips', () {
    testWidgets('renders filter chips with counts', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: CustomerFilterChips(
              selectedFilter: 'all',
              onFilterChanged: (_) {},
              totalCount: 10,
              paidCount: 5,
              partialCount: 3,
              deferredCount: 2,
            ),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.customerAllFilter), findsOneWidget);
      expect(find.text(AppStrings.customerPaidFilter), findsOneWidget);
      expect(find.text(AppStrings.customerPartialFilter), findsOneWidget);
      expect(find.text(AppStrings.customerDeferredFilter), findsOneWidget);
    });

    testWidgets('tapping filter chip triggers callback', (tester) async {
      String? selectedFilter;
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: CustomerFilterChips(
              selectedFilter: 'all',
              onFilterChanged: (f) => selectedFilter = f,
              totalCount: 10,
              paidCount: 5,
              partialCount: 3,
              deferredCount: 2,
            ),
          ),
        ),
      ));
      await tester.pump();

      await tester.tap(find.text(AppStrings.customerPaidFilter));
      expect(selectedFilter, 'paid');
    });
  });
}

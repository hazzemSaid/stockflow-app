import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockflow/features/customers/domain/entities/customer_transaction.dart';
import 'package:stockflow/features/customers/presentation/widgets/customer_transaction_list.dart';
import 'package:stockflow/core/constants/app_strings.dart';

Widget createTestWidget({
  int selectedTab = 0,
  List<CustomerTransaction> transactions = const [],
}) {
  return ScreenUtilInit(
    designSize: const Size(320, 762),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
        locale: const Locale('ar', 'EG'),
        home: Scaffold(
          body: CustomerTransactionList(
            selectedTab: selectedTab,
            transactions: transactions,
          ),
        ),
      );
    },
  );
}

void main() {
  group('CustomerTransactionList', () {
    final transactions = [
      CustomerTransaction(
        id: 'inv-001',
        type: 'invoice',
        amount: 2000,
        createdAt: DateTime(2026, 6, 10),
        title: 'فاتورة مبيعات #inv-001',
        subtitle: '1000 ج.م متبقي',
        statusLabel: 'مدفوع جزئياً',
      ),
      CustomerTransaction(
        id: 'pay-001',
        type: 'payment',
        amount: 1000,
        createdAt: DateTime(2026, 6, 12),
        title: 'سداد دفعة نقداً',
        subtitle: 'تم الاستلام بنجاح',
        statusLabel: 'مستلم',
      ),
    ];

    testWidgets('renders all transactions when selectedTab is 0', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedTab: 0,
        transactions: transactions,
      ));
      await tester.pumpAndSettle();

      expect(find.text('فاتورة مبيعات #inv-001'), findsOneWidget);
      expect(find.text('سداد دفعة نقداً'), findsOneWidget);
    });

    testWidgets('filters by invoices when selectedTab is 1', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedTab: 1,
        transactions: transactions,
      ));
      await tester.pumpAndSettle();

      expect(find.text('فاتورة مبيعات #inv-001'), findsOneWidget);
      expect(find.text('سداد دفعة نقداً'), findsNothing);
    });

    testWidgets('filters by payments when selectedTab is 2', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedTab: 2,
        transactions: transactions,
      ));
      await tester.pumpAndSettle();

      expect(find.text('سداد دفعة نقداً'), findsOneWidget);
      expect(find.text('فاتورة مبيعات #inv-001'), findsNothing);
    });

    testWidgets('shows empty state when no transactions', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedTab: 0,
        transactions: [],
      ));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emptyInvoices), findsOneWidget);
    });

    testWidgets('opens opening_debt transaction', (tester) async {
      final withOpeningDebt = [
        ...transactions,
        CustomerTransaction(
          id: 'opening_debt',
          type: 'opening_debt',
          amount: 500,
          createdAt: DateTime(2026, 6, 1),
          title: 'رصيد افتتاحي',
          subtitle: 'عند إنشاء الحساب',
          statusLabel: 'معلق',
        ),
      ];

      await tester.pumpWidget(createTestWidget(
        selectedTab: 0,
        transactions: withOpeningDebt,
      ));
      await tester.pumpAndSettle();

      expect(find.text('رصيد افتتاحي'), findsOneWidget);
    });
  });
}

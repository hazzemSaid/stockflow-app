import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:stockflow/features/products/presentation/pages/products_screen.dart';
import 'package:stockflow/features/products/presentation/widgets/product_screen_header.dart';
import 'package:stockflow/features/products/presentation/widgets/product_loading_view.dart';
import 'package:stockflow/features/products/presentation/widgets/product_empty_view.dart';
import 'package:stockflow/features/products/presentation/widgets/product_error_view.dart';
import '../shared/test_setup.dart';

class MockProductsCubit extends Cubit<ProductsState> implements ProductsCubit {
  MockProductsCubit(super.state);

  @override
  Future<void> loadProducts({required String companyId}) async {}

  @override
  Future<void> loadMore({required String companyId}) async {}

  @override
  void updateSearchQuery(String query, {required String companyId}) {}

  @override
  Future<void> refresh({required String companyId}) async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Products Screen - States', () {
    testWidgets('shows loading view in initial/loading state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<ProductsCubit>(
          create: (_) => MockProductsCubit(
            const ProductsState(status: ProductsStatus.loading),
          ),
          child: const ProductsScreen(),
        ),
      ));
      await tester.pump();
      expect(find.byType(ProductLoadingView), findsOneWidget);
    });

    testWidgets('shows empty view when no products', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<ProductsCubit>(
          create: (_) => MockProductsCubit(
            const ProductsState(status: ProductsStatus.empty),
          ),
          child: const ProductsScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text(AppStrings.emptyProducts), findsOneWidget);
    });

    testWidgets('shows error view on error state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<ProductsCubit>(
          create: (_) => MockProductsCubit(
            const ProductsState(
              status: ProductsStatus.error,
              errorMessage: 'فشل التحميل',
            ),
          ),
          child: const ProductsScreen(),
        ),
      ));
      await tester.pump();
      expect(find.text('فشل التحميل'), findsOneWidget);
    });

    testWidgets('renders product screen header with count', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductScreenHeader(totalCount: 15),
        ),
      ));
      await tester.pump();

      expect(find.text(AppStrings.productsTitle), findsOneWidget);
      expect(find.textContaining('15'), findsOneWidget);
    });
  });

  group('Product Empty View', () {
    testWidgets('renders empty message', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: const ProductEmptyView(message: AppStrings.emptyProducts),
      ));
      await tester.pump();

      expect(find.text(AppStrings.emptyProducts), findsOneWidget);
    });

    testWidgets('renders search empty message', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: const ProductEmptyView(message: AppStrings.productEmptySearch),
      ));
      await tester.pump();

      expect(find.text(AppStrings.productEmptySearch), findsOneWidget);
    });
  });

  group('Product Error View', () {
    testWidgets('renders error message with retry button', (tester) async {
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: ProductErrorView(
          message: 'خطأ في التحميل',
          onRetry: () {},
        ),
      ));
      await tester.pump();

      expect(find.text('خطأ في التحميل'), findsOneWidget);
      expect(find.text(AppStrings.productRetry), findsOneWidget);
    });

    testWidgets('retry button is tappable', (tester) async {
      bool retryCalled = false;
      await tester.pumpWidget(TestSetup.wrapWithApp(
        child: ProductErrorView(
          message: 'خطأ',
          onRetry: () => retryCalled = true,
        ),
      ));
      await tester.pump();

      await tester.tap(find.text(AppStrings.productRetry));
      expect(retryCalled, isTrue);
    });
  });
}

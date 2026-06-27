import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stockflow/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:stockflow/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:stockflow/features/dashboard/presentation/widgets/dashboard_view.dart';

class MockDashboardCubit extends Cubit<DashboardState> implements DashboardCubit {
  MockDashboardCubit() : super(const DashboardInitial());

  @override
  Future<void> loadDashboard(String companyId) async {}

  @override
  Future<void> refresh() async {}
}

class MockDashboardCubitLoading extends Cubit<DashboardState>
    implements DashboardCubit {
  MockDashboardCubitLoading() : super(const DashboardLoading());

  @override
  Future<void> loadDashboard(String companyId) async {}

  @override
  Future<void> refresh() async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Screen - Loading State', () {
    testWidgets('shows loading shimmer when dashboard is loading',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<DashboardCubit>(
          create: (_) => MockDashboardCubitLoading(),
          child: const DashboardView(),
        ),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Dashboard Screen - Initial State', () {
    testWidgets('shows loading indicator in initial state', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<DashboardCubit>(
          create: (_) => MockDashboardCubit(),
          child: const DashboardView(),
        ),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

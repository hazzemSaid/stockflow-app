import '../../../../core/constants/app_routes.dart';

class AppShellState {
  final String currentRoute;
  final int selectedIndex;

  const AppShellState({
    this.currentRoute = AppRoutes.dashboard,
    this.selectedIndex = 0,
  });

  AppShellState copyWith({
    String? currentRoute,
    int? selectedIndex,
  }) {
    return AppShellState(
      currentRoute: currentRoute ?? this.currentRoute,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

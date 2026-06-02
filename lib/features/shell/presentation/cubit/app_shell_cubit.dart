import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import 'app_shell_state.dart';

class AppShellCubit extends Cubit<AppShellState> {
  AppShellCubit() : super(const AppShellState());

  static const List<String> routeOrder = AppRoutes.shellRoutes;

  int indexForRoute(String route) {
    final idx = routeOrder.indexOf(route);
    return idx >= 0 ? idx : 0;
  }

  void syncRoute(String route, int selectedIndex) {
    if (route == state.currentRoute && selectedIndex == state.selectedIndex) {
      return;
    }
    emit(state.copyWith(currentRoute: route, selectedIndex: selectedIndex));
  }
}

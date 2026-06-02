import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/features/shell/presentation/cubit/app_shell_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../cubit/app_shell_cubit.dart';
import '../widgets/stockflow_bottom_nav.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _lastLocation;
  int? _lastIndex;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = widget.navigationShell.currentIndex;

    return BlocProvider(
      create: (_) => AppShellCubit()..syncRoute(location, currentIndex),
      child: Builder(
        builder: (context) {
          _syncRoute(context, location, currentIndex);
          return BlocListener<AppShellCubit, AppShellState>(
            listenWhen: (previous, current) =>
                previous.currentRoute != current.currentRoute ||
                previous.selectedIndex != current.selectedIndex,
            listener: (context, state) {
              if (state.currentRoute != location) {
                context.go(state.currentRoute);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.appBackground,
              body: widget.navigationShell,
              bottomNavigationBar: StockFlowBottomNav(
                navigationShell: widget.navigationShell,
              ),
            ),
          );
        },
      ),
    );
  }

  void _syncRoute(BuildContext context, String location, int index) {
    if (_lastLocation == location && _lastIndex == index) {
      return;
    }
    _lastLocation = location;
    _lastIndex = index;
    context.read<AppShellCubit>().syncRoute(location, index);
  }
}

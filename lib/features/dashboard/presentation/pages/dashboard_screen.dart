import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/core/di/service_locator.dart';
import 'package:makhzanflow/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../widgets/dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardCubit>(
      create: (_) => sl<DashboardCubit>(),
      child: const DashboardView(),
    );
  }
}

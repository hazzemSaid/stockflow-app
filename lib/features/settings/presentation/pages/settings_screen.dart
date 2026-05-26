import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return ListView(
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('تسجيل الخروج'),
            onTap: () => authCubit.signOut(),
          ),
        ),
      ],
    );
  }
}

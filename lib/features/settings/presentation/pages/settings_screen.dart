import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/company/company_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/widgets/company_switcher.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          const CompanySwitcher(),
          SizedBox(height: AppSizes.spacingMedium),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.business,
                label: AppStrings.companySettings,
                onTap: () => context.go('${AppRoutes.settings}/company'),
              ),
              Divider(height: 1, indent: AppSizes.spacingXLarge * 2),
              _SettingsTile(
                icon: Icons.people,
                label: AppStrings.teamMembers,
                onTap: () => context.go('${AppRoutes.settings}/members'),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingLarge),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text(AppStrings.signOut),
              onTap: () {
                context.read<CompanyCubit>().clearCompany();
                sl<PermissionService>().clear();
                authCubit.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: children));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: Icon(Icons.arrow_forward_ios, size: AppSizes.iconSmall),
      onTap: onTap,
    );
  }
}

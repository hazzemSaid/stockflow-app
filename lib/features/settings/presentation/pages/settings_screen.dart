import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/company/company_cubit.dart';
import '../../../../core/company/company_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/widgets/company_switcher.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;

  Future<void> _handleSignOut() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    final companyCubit = context.read<CompanyCubit>();
    final authCubit = context.read<AuthCubit>();
    final router = GoRouter.of(context);
    try {
      await companyCubit.clearCompany();
      sl<PermissionService>().clear();
      await authCubit.signOut();
      if (mounted) router.go(AppRoutes.login);
    } catch (_) {
      if (mounted) router.go(AppRoutes.login);
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyState = context.watch<CompanyCubit>().state;
    final isOwner =
        companyState is CompanySelected &&
        companyState.membership?.isOwner == true;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        children: [
          const CompanySwitcher(),
          SizedBox(height: AppSizes.spacingMedium),
          _SettingsCard(
            children: [
              if (isOwner)
                _SettingsTile(
                  icon: Icons.business,
                  label: AppStrings.companySettings,
                  onTap: () => context.go('${AppRoutes.settings}/company'),
                ),
              if (isOwner)
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
              trailing: _isLoggingOut
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.error,
                      ),
                    )
                  : null,
              enabled: !_isLoggingOut,
              onTap: _isLoggingOut ? null : _handleSignOut,
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

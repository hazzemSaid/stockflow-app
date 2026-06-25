import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/core/widgets/app_snackbar.dart';
import 'package:stockflow/features/companies/presentation/cubit/join_company_cubit.dart';

class JoinBusinessScreen extends StatefulWidget {
  const JoinBusinessScreen({super.key});

  @override
  State<JoinBusinessScreen> createState() => _JoinBusinessScreenState();
}

class _JoinBusinessScreenState extends State<JoinBusinessScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final JoinCompanyCubit _cubit;
  final _inviteCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Create ONE instance here — owned by this State, closed on dispose.
    _cubit = sl<JoinCompanyCubit>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inviteCodeController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _joinByCode() async {
    if (!_formKey.currentState!.validate()) return;
    _cubit.joinByCode(_inviteCodeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<JoinCompanyCubit, JoinCompanyState>(
        listener: (context, state) {
          switch (state) {
            case JoinCompanyCodeSent _:
              // Pass the same cubit to pending screen so polling continues.
              context.push(AppRoutes.welcomePending, extra: _cubit);
            case JoinCompanyError _:
              AppSnackbar.error(context, state.message);
            case JoinCompanyApproved _:
              context.go(AppRoutes.dashboard);
            default:
              break;
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.appBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: Text(AppStrings.joinCompany),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: AppStrings.inviteCode),
                  Tab(text: AppStrings.inviteLink),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInviteCodeTab(),
                    _buildInviteLinkTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteCodeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.spacingXLarge),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.spacingLarge),
            Icon(
              Icons.vpn_key_outlined,
              size: AppSizes.iconXLarge * 1.6,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSizes.spacingLarge),
            Text(
              AppStrings.inviteCodeTitle,
              style: TextStyle(
                fontSize: AppSizes.fontXLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              AppStrings.inviteCodeSubtitle,
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.spacingLarge),
            TextFormField(
              controller: _inviteCodeController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.fontXLarge,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.inviteCodeHint,
                hintStyle: TextStyle(
                  letterSpacing: 4,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.inviteCodeRequired;
                }
                return null;
              },
            ),
            SizedBox(height: AppSizes.spacingXLarge),
            BlocBuilder<JoinCompanyCubit, JoinCompanyState>(
              builder: (context, state) {
                final isLoading = state is JoinCompanyLoading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _joinByCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.all(AppSizes.spacingMedium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: AppSizes.iconMedium,
                            width: AppSizes.iconMedium,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSizes.strokeWidthMedium,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            AppStrings.joinButton,
                            style: TextStyle(fontSize: AppSizes.fontLarge),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteLinkTab() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.spacingXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_outlined,
            size: AppSizes.iconXLarge * 1.6,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSizes.spacingLarge),
          Text(
            AppStrings.inviteLinkTitle,
            style: TextStyle(
              fontSize: AppSizes.fontXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          Text(
            AppStrings.inviteLinkSubtitle,
            style: TextStyle(
              fontSize: AppSizes.fontMedium,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.spacingXLarge),
          TextField(
            decoration: InputDecoration(
              hintText: AppStrings.inviteLinkHint,
              prefixIcon: Icon(Icons.content_paste),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

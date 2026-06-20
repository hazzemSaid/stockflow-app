import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/customer_details/customer_details_cubit.dart';
import '../widgets/customer_action_buttons.dart';
import '../widgets/customer_debt_summary_card.dart';
import '../widgets/customer_details_header.dart';
import '../widgets/customer_transaction_list.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  late final CustomerDetailsCubit _cubit;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CustomerDetailsCubit>();
    _cubit.loadCustomer(widget.customerId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: BlocConsumer<CustomerDetailsCubit, CustomerDetailsState>(
          listener: (context, state) {
            if (state.status == CustomerDetailsStatus.error &&
                state.failure != null) {
              AppSnackbar.error(
                context,
                state.failure?.message ?? AppStrings.unexpectedError,
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case CustomerDetailsStatus.initial:
              case CustomerDetailsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case CustomerDetailsStatus.error:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.customerLoadError,
                        style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: AppSizes.spacingMedium),
                      ElevatedButton(
                        onPressed: () => _cubit.loadCustomer(widget.customerId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          AppStrings.customerRetry,
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                      ),
                    ],
                  ),
                );
              case CustomerDetailsStatus.success:
                final customer = state.customer!;
                return SafeArea(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxScrolled) => [
                      SliverToBoxAdapter(
                        child: CustomerDetailsHeader(
                          name: customer.name,
                          address: customer.address,
                          phone: customer.phone,
                          imageUrl: customer.imageUrl,
                          onPressed: () async {
                            final updated = await context.push<bool>(
                              AppRoutes.customerEditPath(widget.customerId),
                            );
                            if (updated == true && mounted) {
                              _cubit.loadCustomer(widget.customerId);
                            }
                          },
                        ),
                      ),
                    ],
                    body: SingleChildScrollView(
                      padding: EdgeInsets.only(top: AppSizes.spacingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomerDebtSummaryCard(
                            totalDebt: customer.totalDebt,
                            totalPurchases: customer.totalPurchases,
                            totalPaid: customer.totalPaid,
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          CustomerActionButtons(
                            onNewInvoice: () {
                              context.push(
                                AppRoutes.invoiceCreate,
                                extra: {
                                  'customerId': widget.customerId,
                                  'customerName': customer.name,
                                },
                              );
                            },
                            onRecordPayment: () async {
                              final result = await context.push<bool>(
                                AppRoutes.customerAddPaymentPath(
                                  widget.customerId,
                                ),
                                extra: customer.name,
                              );
                              if (result == true && mounted) {
                                _cubit.loadCustomer(widget.customerId);
                              }
                            },
                          ),
                          SizedBox(height: AppSizes.spacingMedium),
                          _tabBar(),
                          SizedBox(height: AppSizes.spacingSmall),
                          CustomerTransactionList(
                            selectedTab: _selectedTab,
                            transactions: customer.transactions,
                            onViewAll: () => context.push(
                              AppRoutes.customerInvoicesPath(widget.customerId),
                              extra: customer.name,
                            ),
                            onInvoiceTap: (invoiceId) => context.push(
                              AppRoutes.invoiceDetailsPath(invoiceId),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingLarge),
                        ],
                      ),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(AppSizes.spacingTiny),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _tabItem(label: AppStrings.customerAllFilter, index: 0),
            SizedBox(width: AppSizes.spacingTiny),
            _tabItem(label: AppStrings.customerInvoicesTab, index: 1),
            SizedBox(width: AppSizes.spacingTiny),
            _tabItem(label: AppStrings.customerPaymentsTab, index: 2),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({required String label, required int index}) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.spacingSmall),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : null,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: isActive ? AppColors.white : AppColors.inactiveNav,
            ),
          ),
        ),
      ),
    );
  }
}

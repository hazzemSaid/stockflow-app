import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:stockflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
import '../cubit/customer_invoices/customer_invoices_cubit.dart';

class CustomerInvoicesScreen extends StatefulWidget {
  final String customerId;
  final String customerName;

  const CustomerInvoicesScreen({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CustomerInvoicesScreen> createState() => _CustomerInvoicesScreenState();
}

class _CustomerInvoicesScreenState extends State<CustomerInvoicesScreen> {
  late final CustomerInvoicesCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final companyState = context.read<CompanyCubit>().state;
    final companyId = (companyState as CompanySelected).companyId;
    _cubit = CustomerInvoicesCubit(
      getInvoicesUseCase: sl<GetInvoicesUseCase>(),
      customerId: widget.customerId,
      companyId: companyId,
      customerName: widget.customerName,
    );
    _cubit.loadInvoices();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        title: Text(
          '${AppStrings.customerInvoicesTab} - ${widget.customerName}',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontLarge,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<CustomerInvoicesCubit, CustomerInvoicesState>(
          builder: (context, state) {
            return switch (state.status) {
              CustomerInvoicesStatus.initial ||
              CustomerInvoicesStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              CustomerInvoicesStatus.error => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.failure?.message ?? AppStrings.unexpectedError,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    SizedBox(height: AppSizes.spacingMedium),
                    TextButton(
                      onPressed: () => _cubit.loadInvoices(),
                      child: Text(
                        AppStrings.productRetry,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              ),
              CustomerInvoicesStatus.loadingMore ||
              CustomerInvoicesStatus.success => _buildList(state),
              CustomerInvoicesStatus.empty => Center(
                child: Text(
                  AppStrings.emptyInvoices,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildList(CustomerInvoicesState state) {
    if (state.invoices.isEmpty) {
      return Center(
        child: Text(
          AppStrings.emptyInvoices,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      itemCount: state.invoices.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.invoices.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final invoice = state.invoices[index];
        return _invoiceItem(invoice);
      },
    );
  }

  Widget _invoiceItem(Invoice invoice) {
    final amountColor = invoice.paymentStatus == InvoiceStatus.debt
        ? AppColors.secondary
        : AppColors.primary;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.invoiceDetailsPath(invoice.id)),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.spacingSmall),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 10.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(Icons.receipt, size: 16.w, color: AppColors.primary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${AppStrings.invoiceNo} #${invoice.id.substring(0, invoice.id.length > 8 ? 8 : invoice.id.length)}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingSmall),
                      _statusChip(invoice.paymentStatus),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacingTiny),
                  Text(
                    invoice.createdAt != null
                        ? _formatDate(invoice.createdAt!)
                        : '',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  invoice.totalAmount.toInt().toString(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                    color: amountColor,
                  ),
                ),
                Text(
                  AppStrings.currencyEg,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9.sp,
                    color: AppColors.hintText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(InvoiceStatus status) {
    final isDebt = status == InvoiceStatus.debt;
    final isPartial = status == InvoiceStatus.partial;
    String label;
    Color textColor;
    Color bgColor;

    if (isDebt) {
      label = AppStrings.customerDeferred;
      textColor = AppColors.redDark;
      bgColor = AppColors.lightRed;
    } else if (isPartial) {
      label = AppStrings.addPaymentStatusPartial;
      textColor = AppColors.accent;
      bgColor = AppColors.lightOrange;
    } else {
      label = AppStrings.customerPaidFilter;
      textColor = AppColors.primary;
      bgColor = AppColors.lightPrimaryBg;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSmall,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontSmall,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}/${local.month}/${local.day}';
  }
}

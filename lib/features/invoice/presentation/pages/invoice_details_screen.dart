import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/presentation/cubit/invoice_details/invoice_details_cubit.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_company_header.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_info_section.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_products_table.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_summary_section.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_payment_status.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_payment_history.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_reminder_footer.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_loading.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_details_error.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailsScreen({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  late final InvoiceDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<InvoiceDetailsCubit>();
    _cubit.loadInvoice(widget.invoiceId);
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
        appBar: AppBar(
          backgroundColor: AppColors.appBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.textDark,
              size: AppSizes.iconMedium,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            AppStrings.invoiceDetailsTitle,
            style: TextStyle(
              fontSize: AppSizes.fontXLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.print, color: AppColors.primary),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.share, color: AppColors.primary),
            ),
          ],
        ),
        body: BlocBuilder<InvoiceDetailsCubit, InvoiceDetailsState>(
          builder: (context, state) {
            if (state is InvoiceDetailsLoading) {
              return const InvoiceDetailsLoadingState();
            }
            if (state is InvoiceDetailsError) {
              return InvoiceDetailsErrorState(
                message: state.failure.message,
              );
            }
            if (state is InvoiceDetailsLoaded) {
              return _InvoiceDetailContent(invoice: state.invoice);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InvoiceDetailContent extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceDetailContent({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final dateStr = invoice.createdAt != null
        ? DateFormat('yyyy/MM/dd').format(invoice.createdAt!)
        : '--';

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > 600
        ? AppSizes.spacingXLarge
        : AppSizes.spacingMedium;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSizes.spacingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvoiceDetailsCompanyHeader(),
          SizedBox(height: AppSizes.spacingMedium),
          InvoiceDetailsInfoSection(invoice: invoice, dateStr: dateStr),
          SizedBox(height: AppSizes.spacingMedium),
          InvoiceDetailsProductsTable(invoice: invoice),
          SizedBox(height: AppSizes.spacingMedium),
          InvoiceDetailsSummarySection(invoice: invoice),
          SizedBox(height: AppSizes.spacingMedium),
          InvoiceDetailsPaymentStatus(invoice: invoice),
          if (invoice.payments.isNotEmpty) ...[
            SizedBox(height: AppSizes.spacingMedium),
            InvoiceDetailsPaymentHistory(invoice: invoice),
          ],
          if (invoice.remainingAmount > 0) ...[
            SizedBox(height: AppSizes.spacingLarge),
            const InvoiceDetailsReminderFooter(),
          ],
        ],
      ),
    );
  }
}

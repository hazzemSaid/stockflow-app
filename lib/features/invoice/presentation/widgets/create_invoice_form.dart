import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
import 'package:stockflow/features/invoice/presentation/cubit/customer_picker/customer_picker_cubit.dart';
import 'package:stockflow/features/invoice/presentation/cubit/product_picker/product_picker_cubit.dart';
import 'package:stockflow/features/invoice/presentation/pages/customer_picker_screen.dart';
import 'package:stockflow/features/invoice/presentation/pages/product_picker_screen.dart';
import 'package:stockflow/features/invoice/presentation/widgets/customer_selection_card.dart';
import 'package:stockflow/features/invoice/presentation/widgets/discount_section.dart';
import 'package:stockflow/features/invoice/presentation/widgets/empty_products_placeholder.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_bottom_bar.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_summary_card.dart';
import 'package:stockflow/features/invoice/presentation/widgets/paid_now_input.dart';
import 'package:stockflow/features/invoice/presentation/widgets/payment_method_chips.dart';
import 'package:stockflow/features/invoice/presentation/widgets/product_item_row.dart';
import 'package:stockflow/features/invoice/presentation/widgets/products_section_header.dart';

class CreateInvoiceForm extends StatelessWidget {
  final bool lockCustomer;

  const CreateInvoiceForm({super.key, this.lockCustomer = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateInvoiceCubit>();
    final state = cubit.state;
    final loaded = state is CreateInvoiceFormState
        ? state
        : CreateInvoiceLoaded();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerSelectionCard(
                  customer: loaded.selectedCustomer,
                  onTap: lockCustomer
                      ? null
                      : () => _openCustomerPicker(context, cubit),
                ),
                SizedBox(height: AppSizes.spacingMedium),
                ProductsSectionHeader(
                  productCount: loaded.products.length,
                  onAddProduct: () => _openProductPicker(context),
                ),
                SizedBox(height: AppSizes.spacingSmall),
                if (loaded.products.isEmpty)
                  EmptyProductsPlaceholder(
                    onTap: () => _openProductPicker(context),
                  )
                else
                  ...loaded.products.map(
                    (p) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSizes.spacingSmall,
                      ),
                      child: ProductItemRow(
                        cubit: cubit,
                        productId: p.productId,
                        productName: p.productName,
                        unitPrice: p.unitPrice,
                        quantity: p.quantity,
                      ),
                    ),
                  ),
                SizedBox(height: AppSizes.spacingMedium),
                DiscountSection(cubit: cubit),
                SizedBox(height: AppSizes.spacingMedium),
                PaymentMethodChips(cubit: cubit),
                SizedBox(height: AppSizes.spacingMedium),
                PaidNowInput(cubit: cubit),
                SizedBox(height: AppSizes.spacingMedium),
                const InvoiceSummaryCard(),
              ],
            ),
          ),
        ),
        InvoiceBottomBar(
          onConfirm: () => cubit.submit(),
        ),
      ],
    );
  }
}

void _openCustomerPicker(BuildContext context, CreateInvoiceCubit cubit) {
  final companyState = context.read<CompanyCubit>().state;
  final companyId = (companyState as CompanySelected).companyId;
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => CustomerPickerCubit(
          getCustomersUseCase: sl(),
          companyId: companyId,
        ),
        child: CustomerPickerScreen(createCubit: cubit),
      ),
    ),
  );
}

void _openProductPicker(BuildContext context) {
  final createCubit = context.read<CreateInvoiceCubit>();
  final companyState = context.read<CompanyCubit>().state;
  final companyId = (companyState as CompanySelected).companyId;
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (ctx) => ProductPickerCubit(
          getProductsUseCase: sl(),
          companyId: companyId,
        ),
        child: ProductPickerScreen(createCubit: createCubit),
      ),
    ),
  );
}

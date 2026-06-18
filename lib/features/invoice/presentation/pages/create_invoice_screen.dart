import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/core/widgets/app_snackbar.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
import 'package:stockflow/features/invoice/presentation/widgets/create_invoice_form.dart';
import 'package:stockflow/features/invoice/presentation/widgets/create_invoice_loading.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  late final CreateInvoiceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CreateInvoiceCubit>();
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
      child: BlocListener<CreateInvoiceCubit, CreateInvoiceState>(
        listener: (context, state) {
          if (state is CreateInvoiceSuccess) {
            AppSnackbar.success(context, AppStrings.invoiceCreated);
            context.pop();
          }
          if (state is CreateInvoiceError) {
            AppSnackbar.error(context, state.failure.message);
          }
        },
        child: BlocBuilder<CreateInvoiceCubit, CreateInvoiceState>(
          builder: (context, state) {
            return Scaffold(
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
                  AppStrings.invoiceCreateSale,
                  style: TextStyle(
                    fontSize: AppSizes.fontXLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              body: state is CreateInvoiceLoading
                  ? const CreateInvoiceLoadingState()
                  : CreateInvoiceForm(),
            );
          },
        ),
      ),
    );
  }
}


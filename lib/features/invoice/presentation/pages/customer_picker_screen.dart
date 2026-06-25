import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
import 'package:stockflow/features/invoice/presentation/cubit/customer_picker/customer_picker_cubit.dart';
import 'package:stockflow/features/invoice/presentation/widgets/customer_picker_loading.dart';
import 'package:stockflow/features/invoice/presentation/widgets/customer_picker_empty.dart';

class CustomerPickerScreen extends StatefulWidget {
  final CreateInvoiceCubit createCubit;

  const CustomerPickerScreen({super.key, required this.createCubit});

  @override
  State<CustomerPickerScreen> createState() => _CustomerPickerScreenState();
}

class _CustomerPickerScreenState extends State<CustomerPickerScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerPickerCubit>().loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.customersTitle,
          style: TextStyle(
            fontSize: AppSizes.fontXLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSizes.spacingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppStrings.customersSearchHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.searchBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSmall,
                ),
              ),
              onChanged: (query) =>
                  context.read<CustomerPickerCubit>().updateSearchQuery(query),
            ),
          ),
          Expanded(
            child: BlocBuilder<CustomerPickerCubit, CustomerPickerState>(
              builder: (context, state) {
                switch (state.status) {
                  case CustomerPickerStatus.initial:
                  case CustomerPickerStatus.loading:
                    return const CustomerPickerLoadingState();
                  case CustomerPickerStatus.error:
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.spacingMedium),
                        child: Text(
                          state.failure?.message ?? 'Error loading customers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.redDark,
                            fontSize: AppSizes.fontMedium,
                          ),
                        ),
                      ),
                    );
                  case CustomerPickerStatus.empty:
                    return const CustomerPickerEmptyState();
                  case CustomerPickerStatus.success:
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingMedium,
                      ),
                      itemCount: state.customers.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: AppSizes.spacingTiny,
                        color: AppColors.inputBorder,
                      ),
                      itemBuilder: (_, index) {
                        final customer = state.customers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: AppSizes.spacingTiny,
                          ),
                          leading: Container(
                            width: AppSizes.iconLarge,
                            height: AppSizes.iconLarge,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSmall,
                              ),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: AppSizes.iconMedium,
                            ),
                          ),
                          title: Text(
                            customer.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                              fontSize: AppSizes.fontLarge,
                            ),
                          ),
                          subtitle: customer.phone != null
                              ? Text(
                                  customer.phone!,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontMedium,
                                  ),
                                )
                              : null,
                          trailing: Icon(
                            Icons.chevron_left,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            widget.createCubit.selectCustomer(customer);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

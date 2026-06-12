import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
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
  List<Customer> _allCustomers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    final result = await sl<GetCustomersUseCase>()();
    result.fold(
      (_) {
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      (customers) {
        if (!mounted) return;
        setState(() {
          _allCustomers = customers;
          _filteredCustomers = customers;
          _isLoading = false;
        });
      },
    );
  }

  void _search(String query) {
    setState(() {
      _filteredCustomers = query.isEmpty
          ? _allCustomers
          : _allCustomers
              .where((c) =>
                  c.name.toLowerCase().contains(query.toLowerCase()) ||
                  (c.phone?.contains(query) ?? false))
              .toList();
    });
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
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const CustomerPickerLoadingState()
                : _filteredCustomers.isEmpty
                    ? const CustomerPickerEmptyState()
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingMedium,
                        ),
                        itemCount: _filteredCustomers.length,
                        separatorBuilder: (_, _2) => Divider(
                          height: 1,
                          indent: AppSizes.spacingTiny,
                          color: AppColors.inputBorder,
                        ),
                        itemBuilder: (_, index) {
                          final customer = _filteredCustomers[index];
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
                      ),
          ),
        ],
      ),
    );
  }
}

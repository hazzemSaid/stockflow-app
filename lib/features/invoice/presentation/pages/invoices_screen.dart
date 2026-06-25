import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/core/permissions/permission_constants.dart';
import 'package:stockflow/core/permissions/permission_gate.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:stockflow/features/invoice/presentation/cubit/invoices/invoices_cubit.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_card.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoices_filter_chip.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoices_empty_state.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final _getCustomersUseCase = sl<GetCustomersUseCase>();
  late final String _companyId;

  InvoiceStatus? _selectedStatus;
  Customer? _selectedCustomer;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    final companyState = context.read<CompanyCubit>().state;
    _companyId = (companyState as CompanySelected).companyId;
    _loadCustomers();
    context.read<InvoicesCubit>().loadInvoices(_companyId);
  }

  Future<void> _loadCustomers() async {
    final result = await _getCustomersUseCase(companyId: _companyId);
    result.fold(
      (_) {},
      (customers) => setState(() => _customers = customers),
    );
  }

  void _setStatusFilter(InvoiceStatus? status) {
    final newStatus = _selectedStatus == status ? null : status;
    setState(() => _selectedStatus = newStatus);
    context.read<InvoicesCubit>().setFilter(
      companyId: _companyId,
      statusFilter: newStatus,
      customerId: _selectedCustomer?.id,
    );
  }

  void _setCustomerFilter(Customer? customer) {
    setState(() => _selectedCustomer = customer);
    context.read<InvoicesCubit>().setFilter(
      companyId: _companyId,
      statusFilter: _selectedStatus,
      customerId: customer?.id,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedCustomer = null;
    });
    context.read<InvoicesCubit>().clearFilters(_companyId);
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter =
        _selectedStatus != null || _selectedCustomer != null;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        title: Text(
          AppStrings.navInvoices,
          style: TextStyle(
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<InvoicesCubit>().refresh(_companyId),
        child: Column(
          children: [
            _buildFilters(hasActiveFilter),
            Expanded(
              child: BlocBuilder<InvoicesCubit, InvoicesState>(
                builder: (context, state) {
                  switch (state.status) {
                    case InvoicesStatus.initial:
                    case InvoicesStatus.loading:
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    case InvoicesStatus.error:
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              state.failure?.message ?? 'Error loading invoices',
                              style: TextStyle(color: AppColors.redDark),
                            ),
                          ),
                        ),
                      );
                    case InvoicesStatus.empty:
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.6,
                            child:
                                InvoicesEmptyState(hasFilter: hasActiveFilter),
                          ),
                        ],
                      );
                    case InvoicesStatus.success:
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spacingSmall,
                        ),
                        itemCount: state.invoices.length,
                        itemBuilder: (context, index) => InvoiceCard(
                          invoice: state.invoices[index],
                          onTap: () {
                            context.push(
                              AppRoutes.invoiceDetailsPath(
                                state.invoices[index].id,
                              ),
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PermissionGate(
        permission: PermissionKeys.invoicesCreate,
        child: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.invoiceCreate),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          icon: const Icon(Icons.add),
          label: Text(AppStrings.invoiceNew),
        ),
      ),
    );
  }

  Widget _buildFilters(bool hasActiveFilter) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.sizeOf(context).width;
              final useWrap = screenWidth < 400;
              return useWrap
                  ? Wrap(
                      spacing: AppSizes.spacingSmall,
                      runSpacing: AppSizes.spacingSmall,
                      children: [
                        InvoiceFilterChip(
                          label: AppStrings.customerAllFilter,
                          selected: _selectedStatus == null &&
                              _selectedCustomer == null,
                          onTap: _clearFilters,
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerPaidFilter,
                          selected: _selectedStatus == InvoiceStatus.paid,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.paid),
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerPartialFilter,
                          selected:
                              _selectedStatus == InvoiceStatus.partial,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.partial),
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerDeferredFilter,
                          selected: _selectedStatus == InvoiceStatus.debt,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.debt),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        InvoiceFilterChip(
                          label: AppStrings.customerAllFilter,
                          selected: _selectedStatus == null &&
                              _selectedCustomer == null,
                          onTap: _clearFilters,
                        ),
                        SizedBox(width: AppSizes.spacingSmall),
                        InvoiceFilterChip(
                          label: AppStrings.customerPaidFilter,
                          selected:
                              _selectedStatus == InvoiceStatus.paid,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.paid),
                        ),
                        SizedBox(width: AppSizes.spacingSmall),
                        InvoiceFilterChip(
                          label: AppStrings.customerPartialFilter,
                          selected:
                              _selectedStatus == InvoiceStatus.partial,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.partial),
                        ),
                        SizedBox(width: AppSizes.spacingSmall),
                        InvoiceFilterChip(
                          label: AppStrings.customerDeferredFilter,
                          selected:
                              _selectedStatus == InvoiceStatus.debt,
                          onTap: () =>
                              _setStatusFilter(InvoiceStatus.debt),
                        ),
                      ],
                    );
            },
          ),
          SizedBox(height: AppSizes.spacingSmall),
          _buildCustomerDropdown(),
        ],
      ),
    );
  }

  Widget _buildCustomerDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Customer>(
          value: _selectedCustomer,
          isExpanded: true,
          hint: Text(
            AppStrings.customerSection,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          items: [
            DropdownMenuItem<Customer>(
              value: null,
              child: Text(
                AppStrings.customerAllFilter,
                style: TextStyle(color: AppColors.textDark),
              ),
            ),
            ..._customers.map(
              (c) => DropdownMenuItem(value: c, child: Text(c.name)),
            ),
          ],
          onChanged: (c) => _setCustomerFilter(c),
        ),
      ),
    );
  }
}

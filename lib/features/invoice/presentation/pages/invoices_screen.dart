import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:stockflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoice_card.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoices_filter_chip.dart';
import 'package:stockflow/features/invoice/presentation/widgets/invoices_empty_state.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final _getInvoicesUseCase = sl<GetInvoicesUseCase>();
  final _getCustomersUseCase = sl<GetCustomersUseCase>();

  List<Invoice> _allInvoices = [];
  List<Invoice> _filteredInvoices = [];
  bool _isLoading = true;

  InvoiceStatus? _selectedStatus;
  Customer? _selectedCustomer;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadInvoices();
  }

  Future<void> _loadCustomers() async {
    final result = await _getCustomersUseCase();
    result.fold(
      (_) => setState(() => _customers = []),
      (customers) => setState(() => _customers = customers),
    );
  }

  Future<void> _loadInvoices() async {
    debugPrint(
      '[InvoicesScreen] _loadInvoices statusFilter: $_selectedStatus, customerId: ${_selectedCustomer?.id}',
    );
    setState(() => _isLoading = true);
    final result = await _getInvoicesUseCase(
      statusFilter: _selectedStatus != null ? [_selectedStatus!.name] : null,
      customerId: _selectedCustomer?.id,
    );
    result.fold(
      (failure) {
        debugPrint('[InvoicesScreen] load failed: ${failure.message}');
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
      (invoices) {
        debugPrint('[InvoicesScreen] loaded ${invoices.length} invoices');
        if (!mounted) return;
        setState(() {
          _allInvoices = invoices;
          _filteredInvoices = invoices;
          _isLoading = false;
        });
      },
    );
  }

  void _setStatusFilter(InvoiceStatus? status) {
    setState(() => _selectedStatus = _selectedStatus == status ? null : status);
    _loadInvoices();
  }

  void _setCustomerFilter(Customer? customer) {
    setState(() => _selectedCustomer = customer);
    _loadInvoices();
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedCustomer = null;
    });
    _loadInvoices();
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
        onRefresh: _loadInvoices,
        child: Column(
          children: [
            _buildFilters(hasActiveFilter),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredInvoices.isEmpty
                  ? InvoicesEmptyState(hasFilter: hasActiveFilter)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.spacingSmall,
                      ),
                      itemCount: _filteredInvoices.length,
                      itemBuilder: (context, index) => InvoiceCard(
                        invoice: _filteredInvoices[index],
                        onTap: () {
                          context.push(
                            AppRoutes.invoiceDetailsPath(
                              _filteredInvoices[index].id,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.invoiceCreate),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        icon: const Icon(Icons.add),
        label: Text(AppStrings.invoiceNew),
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
                          selected: _selectedStatus == null && _selectedCustomer == null,
                          onTap: _clearFilters,
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerPaidFilter,
                          selected: _selectedStatus == InvoiceStatus.paid,
                          onTap: () => _setStatusFilter(InvoiceStatus.paid),
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerPartialFilter,
                          selected: _selectedStatus == InvoiceStatus.partial,
                          onTap: () => _setStatusFilter(InvoiceStatus.partial),
                        ),
                        InvoiceFilterChip(
                          label: AppStrings.customerDeferredFilter,
                          selected: _selectedStatus == InvoiceStatus.debt,
                          onTap: () => _setStatusFilter(InvoiceStatus.debt),
                        ),
                      ],
                    )
                  : Row(
                      children: [
              InvoiceFilterChip(
                label: AppStrings.customerAllFilter,
                selected: _selectedStatus == null && _selectedCustomer == null,
                onTap: _clearFilters,
              ),
              SizedBox(width: AppSizes.spacingSmall),
              InvoiceFilterChip(
                label: AppStrings.customerPaidFilter,
                selected: _selectedStatus == InvoiceStatus.paid,
                onTap: () => _setStatusFilter(InvoiceStatus.paid),
              ),
              SizedBox(width: AppSizes.spacingSmall),
              InvoiceFilterChip(
                label: AppStrings.customerPartialFilter,
                selected: _selectedStatus == InvoiceStatus.partial,
                onTap: () => _setStatusFilter(InvoiceStatus.partial),
              ),
              SizedBox(width: AppSizes.spacingSmall),
              InvoiceFilterChip(
                label: AppStrings.customerDeferredFilter,
                selected: _selectedStatus == InvoiceStatus.debt,
                onTap: () => _setStatusFilter(InvoiceStatus.debt),
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



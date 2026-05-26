import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/stockflow_empty_state.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StockFlowEmptyState(
      icon: Icons.receipt_long_outlined,
      message: AppStrings.emptyInvoices,
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/stockflow_empty_state.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StockFlowEmptyState(
      icon: Icons.people_outline,
      message: AppStrings.emptyCustomers,
    );
  }
}

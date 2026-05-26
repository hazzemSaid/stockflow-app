import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/stockflow_empty_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StockFlowEmptyState(
      icon: Icons.inventory_2_outlined,
      message: AppStrings.emptyProducts,
    );
  }
}

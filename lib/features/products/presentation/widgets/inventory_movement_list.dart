import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/inventory_movement.dart';

class InventoryMovementList extends StatelessWidget {
  final List<InventoryMovement> movements;

  const InventoryMovementList({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.productMovementHistory,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        ...movements.take(10).map((movement) {
          return Card(
            margin: EdgeInsets.only(bottom: AppSizes.spacingTiny),
            child: ListTile(
              dense: true,
              leading: Icon(
                movement.isIn
                    ? Icons.add_circle_outline
                    : Icons.remove_circle_outline,
                color: movement.isIn ? AppColors.trendUp : AppColors.trendDown,
              ),
              title: Text(
                '${movement.isIn ? AppStrings.productQuantityIn : AppStrings.productQuantityOut}: ${movement.quantity}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                ),
              ),
              subtitle: movement.note != null
                  ? Text(
                      movement.note!,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                      ),
                    )
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

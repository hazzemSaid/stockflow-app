import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProductQuantityAdjustment extends StatefulWidget {
  final int currentQuantity;
  final bool isLoading;
  final ValueChanged<int> onAdjust;
  final ValueChanged<String> onNoteChanged;

  const ProductQuantityAdjustment({
    super.key,
    required this.currentQuantity,
    this.isLoading = false,
    required this.onAdjust,
    required this.onNoteChanged,
  });

  @override
  State<ProductQuantityAdjustment> createState() =>
      _ProductQuantityAdjustmentState();
}

class _ProductQuantityAdjustmentState
    extends State<ProductQuantityAdjustment> {
  int _delta = 0;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.productQuantityUpdate,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontXLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              '${AppStrings.productQuantityLabel}: ${widget.currentQuantity}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.spacingMedium),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() => _delta = -1);
                            },
                      icon: const Icon(Icons.remove),
                      label: Text(
                        '${AppStrings.productQuantityOut} (${_delta < 0 ? -_delta : 0})',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingSmall),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() => _delta = 1);
                            },
                    icon: const Icon(Icons.add),
                    label: Text(
                      '${AppStrings.productQuantityIn} (${_delta > 0 ? _delta : 0})',
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Row(
              children: [
                _qtyButton('-10', () => _updateDelta(-10)),
                _qtyButton('-5', () => _updateDelta(-5)),
                _qtyButton('-1', () => _updateDelta(-1)),
                _qtyButton('+1', () => _updateDelta(1)),
                _qtyButton('+5', () => _updateDelta(5)),
                _qtyButton('+10', () => _updateDelta(10)),
              ],
            ),
            SizedBox(height: AppSizes.spacingSmall),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: AppStrings.productQuantityNote,
                hintText: AppStrings.productQuantityNote,
              ),
              textDirection: TextDirection.rtl,
              onChanged: widget.onNoteChanged,
            ),
            SizedBox(height: AppSizes.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _delta == 0 || widget.isLoading
                    ? null
                    : () => widget.onAdjust(_delta),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        '${AppStrings.productQuantityUpdate} (${_delta > 0 ? "+$_delta" : _delta})',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8.h),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
            ),
          ),
        ),
      ),
    );
  }

  void _updateDelta(int amount) {
    setState(() {
      final next = _delta + amount;
      final newQty = widget.currentQuantity + next;
      if (newQty >= 0) {
        _delta = next;
      }
    });
  }
}

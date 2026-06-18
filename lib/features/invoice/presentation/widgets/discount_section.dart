import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class DiscountSection extends StatefulWidget {
  final CreateInvoiceCubit cubit;

  const DiscountSection({super.key, required this.cubit});

  @override
  State<DiscountSection> createState() => _DiscountSectionState();
}

class _DiscountSectionState extends State<DiscountSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    widget.cubit.stream.listen((_) {
      final text = widget.cubit.discountValue > 0
          ? widget.cubit.discountValue.toInt().toString()
          : '';
      if (_controller.text != text) {
        _controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPercentage = widget.cubit.discountType == 'percentage';
    final suffix = isPercentage
        ? AppStrings.discountPercentSuffix
        : AppStrings.discountValueSuffix;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.discountLabel,
          style: TextStyle(
            fontSize: AppSizes.fontXLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            _DiscountChip(
              label: AppStrings.byAmount,
              selected: !isPercentage,
              onTap: () => widget.cubit.setDiscountType('fixed'),
            ),
            SizedBox(width: AppSizes.spacingSmall),
            _DiscountChip(
              label: AppStrings.byPercentage,
              selected: isPercentage,
              onTap: () => widget.cubit.setDiscountType('percentage'),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  suffixText: suffix,
                  hintText: '0',
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingMedium,
                    vertical: AppSizes.spacingSmall,
                  ),
                ),
                onChanged: (value) {
                  widget.cubit.setDiscountValue(double.tryParse(value) ?? 0);
                },
              ),
            ),
            if (widget.cubit.discountValue > 0) ...[
              SizedBox(width: AppSizes.spacingSmall),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                  vertical: AppSizes.spacingTiny,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Text(
                  '- ${widget.cubit.discountAmount.toInt()} ${AppStrings.currencyEg}',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DiscountChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DiscountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMedium,
          vertical: AppSizes.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightGreen : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: AppSizes.fontMedium,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class PaidNowInput extends StatefulWidget {
  final CreateInvoiceCubit cubit;

  const PaidNowInput({super.key, required this.cubit});

  @override
  State<PaidNowInput> createState() => _PaidNowInputState();
}

class _PaidNowInputState extends State<PaidNowInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateInvoiceCubit, CreateInvoiceState>(
      buildWhen: (prev, next) => next is CreateInvoiceFormState,
      builder: (context, state) {
        if (state is! CreateInvoiceFormState) return const SizedBox.shrink();
        final loaded = state;

        final text = loaded.paidNow > 0
            ? loaded.paidNow.toInt().toString()
            : '';
        if (_controller.text != text) {
          _controller.value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }

        if (loaded.paymentMethod != 'partial') {
          return const SizedBox.shrink();
        }

        final remaining = loaded.totalAfterDiscount - loaded.paidNow;
        final paidError = loaded.paidNow > loaded.totalAfterDiscount
            ? AppStrings.paidNowExceedError
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.howMuchPaidNow,
              style: TextStyle(
                fontSize: AppSizes.fontXLarge,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
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
                      suffixText: AppStrings.currencyEg,
                      hintText: AppStrings.paidNowHint,
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      errorText: paidError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        borderSide: BorderSide(
                          color: paidError != null
                              ? AppColors.error
                              : AppColors.inputBorder,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingMedium,
                        vertical: AppSizes.spacingSmall,
                      ),
                    ),
                    onChanged: (value) {
                      widget.cubit.setPaidNow(double.tryParse(value) ?? 0);
                    },
                  ),
                ),
                if (remaining > 0 && paidError == null) ...[
                  SizedBox(width: AppSizes.spacingSmall),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingSmall,
                      vertical: AppSizes.spacingTiny,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      '${AppStrings.remainingDebt}: ${remaining.toInt()} ${AppStrings.currencyEg}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSizes.fontSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

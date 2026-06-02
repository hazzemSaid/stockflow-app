import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProductFormFields extends StatefulWidget {
  final String name;
  final String price;
  final String quantity;
  final DateTime? expirationDate;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<DateTime?> onExpirationDateChanged;

  const ProductFormFields({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    this.expirationDate,
    required this.onNameChanged,
    required this.onPriceChanged,
    required this.onQuantityChanged,
    required this.onExpirationDateChanged,
  });

  @override
  State<ProductFormFields> createState() => _ProductFormFieldsState();
}

class _ProductFormFieldsState extends State<ProductFormFields> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(text: widget.price);
    _quantityController = TextEditingController(text: widget.quantity);
  }

  @override
  void didUpdateWidget(ProductFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name && widget.name != _nameController.text) {
      _nameController.text = widget.name;
    }
    if (widget.price != oldWidget.price && widget.price != _priceController.text) {
      _priceController.text = widget.price;
    }
    if (widget.quantity != oldWidget.quantity && widget.quantity != _quantityController.text) {
      _quantityController.text = widget.quantity;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.expirationDate ?? now.add(const Duration(days: 30)),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      widget.onExpirationDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField(
          label: AppStrings.productNameLabel,
          hint: AppStrings.productNameHint,
          controller: _nameController,
          onChanged: widget.onNameChanged,
        ),
        SizedBox(height: AppSizes.spacingMedium),
        _buildField(
          label: AppStrings.productPriceLabel,
          hint: AppStrings.productPriceHint,
          controller: _priceController,
          onChanged: widget.onPriceChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          textDirection: TextDirection.ltr,
        ),
        SizedBox(height: AppSizes.spacingMedium),
        _buildField(
          label: AppStrings.productQuantityLabel,
          hint: AppStrings.productQuantityHint,
          controller: _quantityController,
          onChanged: widget.onQuantityChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textDirection: TextDirection.ltr,
        ),
        SizedBox(height: AppSizes.spacingMedium),
        _buildDateField(),
      ],
    );
  }

  Widget _buildDateField() {
    final text = widget.expirationDate != null
        ? '${widget.expirationDate!.year}-${widget.expirationDate!.month.toString().padLeft(2, '0')}-${widget.expirationDate!.day.toString().padLeft(2, '0')}'
        : null;

    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: AppStrings.productExpirationDateLabel,
          hintText: text ?? AppStrings.productExpirationDateHint,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: text != null
            ? Text(
                text,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                  color: AppColors.textPrimary,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textDirection: textDirection,
      textAlign: textDirection == TextDirection.rtl
          ? TextAlign.right
          : TextAlign.left,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}

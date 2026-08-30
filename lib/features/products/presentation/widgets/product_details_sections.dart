import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/permissions/permission_constants.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/product.dart';
import 'dashed_border_painter.dart';

class ProductDetailsImage extends StatelessWidget {
  final String? imageUrl;

  const ProductDetailsImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          height: 200.h,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(),
          errorWidget: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.primary, width: 2.17),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.primary),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.productImagePicker,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        _infoRow(
          AppStrings.productPriceLabel,
          '${product.price.toStringAsFixed(2)} ${AppStrings.currencyEg}',
        ),
        _infoRow(
          AppStrings.productQuantityLabel,
          product.quantity.toString(),
        ),
        if (product.expirationDate != null)
          _infoRow(
            AppStrings.productExpirationDateLabel,
            '${product.expirationDate!.year}-${product.expirationDate!.month.toString().padLeft(2, '0')}-${product.expirationDate!.day.toString().padLeft(2, '0')}',
          ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ProductActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final ps = sl<PermissionService>();
    final canEdit = ps.hasPermission(PermissionKeys.productsEdit);
    final canDelete = ps.hasPermission(PermissionKeys.productsDelete);

    final children = <Widget>[];
    if (canEdit) {
      children.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: Text(AppStrings.productEdit),
          ),
        ),
      );
    }
    if (canEdit && canDelete) {
      children.add(SizedBox(width: AppSizes.spacingMedium));
    }
    if (canDelete) {
      children.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isDeleting ? null : onDelete,
            icon: isDeleting
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline, color: AppColors.error),
            label: Text(
              AppStrings.productDelete,
              style: TextStyle(color: isDeleting ? null : AppColors.error),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Row(children: children);
  }
}

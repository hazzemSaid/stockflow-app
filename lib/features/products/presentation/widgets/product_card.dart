import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/product.dart';
import 'dashed_border_painter.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final int lowStockThreshold;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.lowStockThreshold = 5,
  });

  bool get _isLowStock => product.quantity <= lowStockThreshold && product.quantity > 0;
  bool get _isOutOfStock => product.quantity == 0;
  bool get _isExpiringSoon => product.expirationDate != null &&
      product.expirationDate!.difference(DateTime.now()).inDays <= 30 &&
      product.expirationDate!.isAfter(DateTime.now());
  bool get _isExpired => product.expirationDate != null &&
      product.expirationDate!.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: Stack(
              children: [
                _buildImage(),
                if (_isOutOfStock) _buildBadge(
                  AppStrings.productOutOfStock, AppColors.error,
                ),
                if (_isLowStock) _buildBadge(
                  AppStrings.productLowStock, AppColors.accent,
                ),
                if (_isExpired) Positioned(
                  top: 4, right: 4,
                  child: _buildSmallBadge(
                    AppStrings.productExpired, AppColors.error,
                  ),
                ),
                if (_isExpiringSoon) Positioned(
                  top: 4, right: 4,
                  child: _buildSmallBadge(
                    AppStrings.productExpiringSoon, AppColors.accent,
                  ),
                ),
              ],
            )),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.spacingSmall),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${product.price.toStringAsFixed(2)} ${AppStrings.currencyEg}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(flex: 1),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${AppStrings.productQuantityLabel}: ${product.quantity}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: AppSizes.fontSmall,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
        color: color.withOpacity(0.85),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 8.sp,
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final placeholder = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EC),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Center(
          child: Icon(
            Icons.inventory_2_outlined,
            size: 24.w,
            color: AppColors.primary,
          ),
        ),
      ),
    );

    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: CachedNetworkImage(
          imageUrl: product.imageUrl!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => placeholder,
          errorWidget: (_, __, ___) => placeholder,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: placeholder,
    );
  }
}

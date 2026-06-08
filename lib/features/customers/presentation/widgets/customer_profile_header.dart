import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class CustomerProfileHeader extends StatelessWidget {
  final String name;
  final String? nameOfficial;
  final String? imageUrl;

  const CustomerProfileHeader({
    super.key,
    required this.name,
    this.nameOfficial,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileImage(),
        SizedBox(height: AppSizes.spacingLarge),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (nameOfficial != null && nameOfficial!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              nameOfficial!,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(48.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: 96.w,
          height: 96.w,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildImagePlaceholder(),
          errorWidget: (_, __, ___) => _buildImagePlaceholder(),
        ),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 96.w,
      height: 96.w,
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryBg,
        borderRadius: BorderRadius.circular(48.r),
      ),
      child: Icon(
        Icons.store_outlined,
        size: 48.w,
        color: AppColors.primary,
      ),
    );
  }
}

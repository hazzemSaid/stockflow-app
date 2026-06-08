import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerImageUploader extends StatelessWidget {
  final String? imageUrl;
  final String? localPath;
  final bool isUploading;
  final VoidCallback onTap;

  const CustomerImageUploader({
    super.key,
    this.imageUrl,
    this.localPath,
    this.isUploading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96.w,
        height: 96.w,
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryBg,
          borderRadius: BorderRadius.circular(48.r),
          border: Border.all(
            color: AppColors.primary,
            width: 1.6,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48.r),
          child: Stack(
            children: [
              if (localPath != null)
                Image.file(
                  File(localPath!),
                  width: 96.w,
                  height: 96.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              else if (imageUrl != null && imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 96.w,
                  height: 96.w,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _buildPlaceholder(),
                  errorWidget: (_, __, ___) => _buildPlaceholder(),
                )
              else
                _buildPlaceholder(),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    color: AppColors.semiTransparent,
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              if (imageUrl != null || localPath != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 16.w,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 24.w,
            color: AppColors.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            AppStrings.customerAddImage,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

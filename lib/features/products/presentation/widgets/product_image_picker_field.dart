import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'dashed_border_painter.dart';

class ProductImagePickerField extends StatelessWidget {
  final String? imageLocalPath;
  final String? imageUploadUrl;
  final bool isUploading;
  final ValueChanged<String> onImagePicked;
  final VoidCallback? onRemove;

  const ProductImagePickerField({
    super.key,
    this.imageLocalPath,
    this.imageUploadUrl,
    this.isUploading = false,
    required this.onImagePicked,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageLocalPath != null || imageUploadUrl != null;

    if (isUploading) {
      return Container(
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.white),
              SizedBox(height: AppSizes.spacingSmall),
              Text(
                AppStrings.productImageUploading,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: SizedBox(
          height: 160.h,
          child: Stack(
            children: [
              if (imageLocalPath != null)
                Image.file(
                  File(imageLocalPath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              else
                Image.network(
                  imageUploadUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => _placeholder(),
                ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.w,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _pickImage(context),
      child: _placeholder(),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Container(
        width: 249.w,
        height: 160.h,
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
                  child: const Icon(
                    Icons.add,
                    size: 14,
                    color: AppColors.primary,
                  ),
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
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                AppStrings.productImagePicker,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  AppStrings.productImageGallery,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: Text(
                  AppStrings.productImageCamera,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final pickedFile = await picker.pickImage(
      // need image from gallery and camera, but image_picker doesn't support multiple sources in one call, so we will show a dialog to let user choose source
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
  }
}

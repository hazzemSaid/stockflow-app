import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerDetailsHeader extends StatelessWidget {
  final String name;
  final String? address;
  final String? phone;
  final String? imageUrl;
  final VoidCallback? onPressed;

  const CustomerDetailsHeader({
    super.key,
    required this.name,
    this.address,
    this.phone,
    this.imageUrl,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first : '?';
    final white70 = AppColors.white.withValues(alpha: 0.7);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusXLarge),
          bottomRight: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(Icons.arrow_back, onPressed: () => context.pop()),
              Text(
                AppStrings.customerDetails,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.sp,
                  color: AppColors.white,
                ),
              ),
              _circleButton(
                Icons.more_horiz,
                onPressed: onPressed,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontXLarge,
                        color: AppColors.white,
                      ),
                    ),
                    if (address != null && address!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              address!,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11.sp,
                                color: white70,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.location_on_outlined,
                              size: 11.w,
                              color: white70,
                            ),
                          ],
                        ),
                      ),
                    if (phone != null && phone!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              phone!,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11.sp,
                                color: white70,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.phone_outlined,
                              size: 11.w,
                              color: white70,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              _buildAvatar(initial),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18.w),
      ),
    );
  }

  Widget _buildAvatar(String initial) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: 64.w,
          height: 64.w,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _avatarPlaceholder(initial),
        ),
      );
    }
    return _avatarPlaceholder(initial);
  }

  Widget _avatarPlaceholder(String initial) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1.6.w,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

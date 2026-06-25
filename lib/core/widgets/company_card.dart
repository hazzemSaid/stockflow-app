import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/widgets/app_network_image.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';

/// A selectable company card used inside the company-switcher bottom sheet.
///
/// Shows an avatar (initials or logo), the company name, business type,
/// an optional role pill, and a trailing check/chevron icon.
class CompanyCard extends StatelessWidget {
  final Company company;
  final bool isSelected;
  final String? roleName;
  final VoidCallback onTap;

  const CompanyCard({
    super.key,
    required this.company,
    required this.isSelected,
    this.roleName,
    required this.onTap,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  Color _avatarBg() {
    if (isSelected) return AppColors.primary;
    return AppColors.chipBg;
  }

  Color _initialsColor() {
    if (isSelected) return AppColors.white;
    return AppColors.darkGrey;
  }

  Color _pillBg() {
    if (roleName == 'Owner' || roleName == 'مالك') return AppColors.lightGreen;
    if (roleName == 'Manager' || roleName == 'مدير') return AppColors.blueLight;
    return AppColors.chipBg;
  }

  Color _pillText() {
    if (roleName == 'Owner' || roleName == 'مالك') return AppColors.primary;
    if (roleName == 'Manager' || roleName == 'مدير') return AppColors.bluePrimary;
    return AppColors.greyMedium;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.19)
        : AppColors.chipBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGreen : AppColors.unselectedCardBg,
          border: Border(
            top: BorderSide(color: borderColor, width: AppSizes.borderWidthThin),
            bottom: BorderSide(color: borderColor, width: AppSizes.borderWidthThin),
            left: BorderSide(color: borderColor, width: AppSizes.borderWidthThin),
            right: isSelected
                ? BorderSide(color: borderColor, width: AppSizes.borderWidthThin * 3)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: _avatarBg(),
                shape: BoxShape.circle,
              ),
              child: company.logoUrl != null && company.logoUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(44.w),
                      child: AppNetworkImage(
                        imageUrl: company.logoUrl!,
                        width: 44.w,
                        height: 44.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        _initials(company.name),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontML,
                          color: _initialsColor(),
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontML,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      if (company.businessType != null)
                        Text(
                          company.businessType!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: AppSizes.fontSmall,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (company.businessType != null && roleName != null)
                        SizedBox(width: 8.w),
                      if (roleName != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _pillBg(),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            roleName!,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: AppSizes.fontSmall,
                              color: _pillText(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.w, color: AppColors.white)
                  : Icon(Icons.chevron_left, size: 16.w, color: AppColors.hintText),
            ),
          ],
        ),
      ),
    );
  }
}

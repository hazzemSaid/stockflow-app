import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';

/// A tappable row with a coloured icon container and a label, used inside
/// the company-switcher bottom‑sheet for actions (create, join, sign out).
class ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final Color labelColor;
  final VoidCallback onTap;
  final bool showTopPadding;
  final bool isLoading;

  const ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    required this.labelColor,
    required this.onTap,
    this.showTopPadding = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: EdgeInsets.only(top: showTopPadding ? 4.h : 0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: isLoading
                    ? Padding(
                        padding: EdgeInsets.all(8.w),
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: iconColor,
                          ),
                        ),
                      )
                    : Icon(icon, size: 16.w, color: iconColor),
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontML,
                  fontWeight: FontWeight.w400,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makhzanflow/features/dashboard/domain/entities/activity_entry.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'activity_type_mapper.dart';

/// Renders a single activity log row with icon, label, subtitle, and time.
class ActivityItemCard extends StatelessWidget {
  const ActivityItemCard({super.key, required this.entry, this.onTap});

  final ActivityEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final action = entry.action;
    final entity = entry.entityType;
    final label = ActivityTypeMapper.toLabel(action, entity);
    final subtitle = ActivityTypeMapper.toSubtitle(entry);
    final icon = ActivityTypeMapper.toIcon(action, entity);
    final iconBg = ActivityTypeMapper.toIconBackground(action, entity);
    final iconColor = ActivityTypeMapper.toIconColor(action, entity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.spacingSmall),
        padding: EdgeInsets.all(AppSizes.spacingSmall),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.w),
            ),
            SizedBox(width: AppSizes.spacingSmall),
            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.spacingSmall),
            // Time ago
            Text(
              _timeAgo(entry.createdAt),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontSmall,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return AppStrings.activityJustNow;
    if (diff.inMinutes < 60)
      return '${diff.inMinutes} ${AppStrings.activityMinutes}';
    if (diff.inHours < 24) return '${diff.inHours} ${AppStrings.activityHours}';
    return '${diff.inDays} ${AppStrings.activityDays}';
  }
}

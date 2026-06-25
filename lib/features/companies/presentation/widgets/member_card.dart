import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';

class MemberCard extends StatelessWidget {
  final CompanyMember member;
  final VoidCallback? onRemove;

  const MemberCard({
    super.key,
    required this.member,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.spacingMedium),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            (member.userName ?? member.userId)[0].toUpperCase(),
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                member.userName ?? AppStrings.unknownUser,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (member.isOwner) ...[
              SizedBox(width: AppSizes.spacingTiny),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                  vertical: AppSizes.spacingTiny,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                  child: Text(
                    AppStrings.ownerRole,
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: member.userEmail != null
            ? Text(
                member.userEmail!,
                style: TextStyle(
                  fontSize: AppSizes.fontSmall,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: onRemove != null
            ? PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                onSelected: (value) {
                  if (value == 'remove') onRemove?.call();
                },
                itemBuilder: (_) => [
                  if (onRemove != null)
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          SizedBox(width: 8),
                          Text(AppStrings.remove),
                        ],
                      ),
                    ),
                ],
              )
            : null,
      ),
    );
  }
}

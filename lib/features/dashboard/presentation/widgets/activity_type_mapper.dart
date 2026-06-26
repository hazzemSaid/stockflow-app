import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockflow/features/dashboard/domain/entities/activity_entry.dart';
import '../../../../core/constants/app_colors.dart';

/// Maps raw [action] + [entityType] strings from the activity log RPC
/// to Arabic display labels and matching icon/color pairs.
///
/// Follows the Open/Closed principle — add new entries here without touching
/// any widget.
abstract final class ActivityTypeMapper {
  /// Returns a localized display label for the action + entity_type pair.
  static String toLabel(String action, String entityType) {
    final key = '${action}_$entityType';
    return _labels[key] ??
        _actionLabels[action] ??
        _entityLabels[entityType] ??
        action;
  }

  /// Returns the icon to display for this activity entry.
  static IconData toIcon(String action, String entityType) {
    final key = '${action}_$entityType';
    return _icons[key] ?? _actionIcons[action] ?? Icons.history_outlined;
  }

  /// Returns the icon container background color.
  static Color toIconBackground(String action, String entityType) {
    return _iconBg[action] ?? AppColors.lightGreen;
  }

  /// Returns the icon foreground color.
  static Color toIconColor(String action, String entityType) {
    return _iconColor[action] ?? AppColors.primary;
  }

  /// Returns the subtitle from [entry.details] when available.
  static String toSubtitle(ActivityEntry entry) {
    final details = entry.details;
    if (details == null) return entry.userName;
    final name = details['name'] as String?;
    final amount = details['amount'];
    if (amount != null) {
      final formatted = _formatAmount(amount);
      return name != null ? '$name · $formatted ج.م' : '$formatted ج.م';
    }
    return name ?? entry.userName;
  }

  // ── private maps ──────────────────────────────────────────────────────────

  static const _labels = <String, String>{
    'create_product': 'أُضيف منتج',
    'update_product': 'تعديل منتج',
    'delete_product': 'حُذف منتج',
    'create_invoice': 'فاتورة جديدة',
    'update_invoice': 'تعديل فاتورة',
    'delete_invoice': 'حُذفت فاتورة',
    'create_customer': 'عميل جديد',
    'update_customer': 'تعديل عميل',
    'delete_customer': 'حُذف عميل',
    'create_payment': 'دفعة مستلمة',
    'update_payment': 'تعديل دفعة',
    'delete_payment': 'حُذفت دفعة',
  };

  static const _actionLabels = <String, String>{
    'create': 'إضافة جديدة',
    'update': 'تعديل',
    'delete': 'حذف',
    'payment': 'دفعة',
  };

  static const _entityLabels = <String, String>{
    'product': 'منتج',
    'invoice': 'فاتورة',
    'customer': 'عميل',
    'payment': 'دفعة',
  };

  static const _icons = <String, IconData>{
    'create_product': Icons.inventory_2_outlined,
    'update_product': Icons.edit_outlined,
    'delete_product': Icons.delete_outline,
    'create_invoice': Icons.receipt_long_outlined,
    'update_invoice': Icons.receipt_outlined,
    'delete_invoice': Icons.delete_outline,
    'create_customer': Icons.person_add_outlined,
    'update_customer': Icons.manage_accounts_outlined,
    'delete_customer': Icons.person_remove_outlined,
    'create_payment': Icons.payments_outlined,
    'update_payment': Icons.edit_outlined,
    'delete_payment': Icons.money_off_outlined,
  };

  static const _actionIcons = <String, IconData>{
    'create': Icons.add_circle_outline,
    'update': Icons.edit_outlined,
    'delete': Icons.delete_outline,
    'payment': Icons.payments_outlined,
  };

  static const _iconBg = <String, Color>{
    'create': AppColors.lightGreen,
    'update': AppColors.lightOrange,
    'delete': AppColors.lightRed,
    'payment': AppColors.lightGreen,
  };

  static const _iconColor = <String, Color>{
    'create': AppColors.primary,
    'update': AppColors.accent,
    'delete': AppColors.trendDown,
    'payment': AppColors.primary,
  };

  static String _formatAmount(dynamic amount) {
    final d = (amount as num).toDouble();
    return NumberFormat('#,##0', 'ar').format(d);
  }
}

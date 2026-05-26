import 'package:flutter/material.dart';

class ActivityItem {
  final String title;
  final String subtitle;
  final String? amount;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color amountColor;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    this.amount,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.amountColor,
  });
}

import 'package:flutter/material.dart';

class DashboardMetric {
  final String title;
  final String value;
  final String? currency;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color valueColor;

  const DashboardMetric({
    required this.title,
    required this.value,
    this.currency,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.valueColor,
  });
}

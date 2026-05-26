import 'package:flutter/material.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });
}

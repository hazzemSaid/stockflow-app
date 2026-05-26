import 'package:flutter/material.dart';

class NavigationDestinationData {
  final String route;
  final String labelAr;
  final String semanticLabelAr;
  final IconData icon;
  final bool isCenterAction;
  final int sortOrderRtl;

  const NavigationDestinationData({
    required this.route,
    required this.labelAr,
    required this.semanticLabelAr,
    required this.icon,
    this.isCenterAction = false,
    required this.sortOrderRtl,
  });
}

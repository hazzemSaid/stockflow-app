import 'package:flutter/material.dart';
import 'package:makhzanflow/core/di/service_locator.dart';
import 'package:makhzanflow/core/permissions/permission_service.dart';

class PermissionGate extends StatelessWidget {
  final String? permission;
  final List<String>? anyPermissions;
  final List<String>? allPermissions;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    this.permission,
    this.anyPermissions,
    this.allPermissions,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final permissionService = sl<PermissionService>();

    bool hasAccess;
    if (permission != null) {
      hasAccess = permissionService.hasPermission(permission!);
    } else if (anyPermissions != null) {
      hasAccess = permissionService.hasAnyPermission(anyPermissions!);
    } else if (allPermissions != null) {
      hasAccess = permissionService.hasAllPermissions(allPermissions!);
    } else {
      hasAccess = true;
    }

    if (hasAccess) return child;
    return fallback ?? const SizedBox.shrink();
  }
}

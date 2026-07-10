import 'package:stockflow/core/permissions/permission_service.dart';

class PermissionServiceImpl implements PermissionService {
  Map<String, dynamic>? _cachedPermissions;
  bool _isOwner = false;

  PermissionServiceImpl();

  @override
  Future<void> loadPermissions(
    String companyId,
    String memberId,
    Map<String, dynamic>? memberPermissions, {
    bool isOwner = false,
  }) async {
    _cachedPermissions = memberPermissions ?? {};
    _isOwner = isOwner;
  }

  @override
  bool hasPermission(String key) {
    if (_isOwner) return true;
    if (_cachedPermissions == null) return false;

    final parts = key.split('.');
    dynamic current = _cachedPermissions;

    for (final part in parts) {
      if (current is! Map<String, dynamic>) return false;
      final value = current[part];
      if (value == null) return false;
      current = value;
    }

    if (current is bool) return current;
    return false;
  }

  @override
  bool hasAnyPermission(List<String> keys) {
    if (_isOwner) return true;
    return keys.any(hasPermission);
  }

  @override
  bool hasAllPermissions(List<String> keys) {
    if (_isOwner) return true;
    return keys.every(hasPermission);
  }

  @override
  bool get isOwner => _isOwner;

  @override
  void clear() {
    _cachedPermissions = null;
    _isOwner = false;
  }
}

import 'package:stockflow/core/permissions/permission_service.dart';

class PermissionServiceImpl implements PermissionService {
  Map<String, bool>? _cachedPermissions;
  bool _isOwner = false;

  PermissionServiceImpl();

  @override
  Future<void> loadPermissions(
    String companyId,
    String memberId,
    Map<String, bool>? memberPermissions, {
    bool isOwner = false,
  }) async {
    _cachedPermissions = memberPermissions ?? {};
    _isOwner = isOwner;
  }

  @override
  bool hasPermission(String key) {
    if (_isOwner) return true;
    if (_cachedPermissions == null) return false;
    return _cachedPermissions![key] ?? false;
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

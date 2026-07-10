abstract class PermissionService {
  Future<void> loadPermissions(String companyId, String memberId, Map<String, dynamic>? memberPermissions, {bool isOwner = false});
  bool hasPermission(String key);
  bool hasAnyPermission(List<String> keys);
  bool hasAllPermissions(List<String> keys);
  bool get isOwner;
  void clear();
}

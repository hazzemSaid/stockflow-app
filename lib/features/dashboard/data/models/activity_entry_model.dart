import 'package:makhzanflow/features/dashboard/domain/entities/activity_entry.dart';

class ActivityEntryModel extends ActivityEntry {
  const ActivityEntryModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.action,
    required super.entityType,
    super.entityId,
    super.details,
    required super.createdAt,
  });

  /// Expects the row shape returned by the [get_activity_log] RPC:
  /// id, user_id, user_name, action, entity_type, entity_id, details, created_at
  factory ActivityEntryModel.fromJson(Map<String, dynamic> json) {
    return ActivityEntryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String? ?? '',
      action: json['action'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String?,
      details: json['details'] != null
          ? Map<String, dynamic>.from(json['details'] as Map)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

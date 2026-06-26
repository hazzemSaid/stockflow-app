import 'package:equatable/equatable.dart';

/// One row from the [get_activity_log] RPC result.
class ActivityEntry extends Equatable {
  const ActivityEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.entityType,
    this.entityId,
    this.details,
    required this.createdAt,
  });

  final String id;
  final String userId;

  /// Display name fetched via JOIN with auth.users in the RPC.
  final String userName;

  /// e.g. 'create', 'update', 'delete', 'payment'
  final String action;

  /// e.g. 'product', 'invoice', 'customer', 'payment'
  final String entityType;

  final String? entityId;

  /// Optional JSONB payload with name / amount / other context.
  final Map<String, dynamic>? details;

  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, userId, userName, action, entityType, entityId, details, createdAt];
}

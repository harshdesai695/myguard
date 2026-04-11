import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';

class CheckpointModel extends CheckpointEntity {
  const CheckpointModel({required super.id, required super.name, required super.location, super.societyId, super.createdAt});
  factory CheckpointModel.fromJson(Map<String, dynamic> json) => CheckpointModel(
    id: json['id'] as String, name: json['name'] as String, location: json['location'] as String,
    societyId: json['societyId'] as String?, createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );
}

class PatrolModel extends PatrolEntity {
  const PatrolModel({required super.id, required super.guardUid, required super.checkpointId, super.societyId, super.scannedAt, super.notes, super.createdAt});
  factory PatrolModel.fromJson(Map<String, dynamic> json) => PatrolModel(
    id: json['id'] as String, guardUid: json['guardUid'] as String, checkpointId: json['checkpointId'] as String,
    societyId: json['societyId'] as String?, scannedAt: json['scannedAt'] != null ? DateTime.parse(json['scannedAt'] as String) : null,
    notes: json['notes'] as String?, createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );
}

class ShiftModel extends ShiftEntity {
  const ShiftModel({required super.id, required super.guardUid, required super.shiftName, required super.startTime, required super.endTime, required super.date, super.societyId, super.status, super.createdAt});
  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
    id: json['id'] as String, guardUid: json['guardUid'] as String, shiftName: json['shiftName'] as String,
    startTime: json['startTime'] as String, endTime: json['endTime'] as String, date: json['date'] as String,
    societyId: json['societyId'] as String?, status: json['status'] as String?, createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );
}

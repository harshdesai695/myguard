import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart';

class PanicAlertModel extends PanicAlertEntity {
  const PanicAlertModel({required super.id, super.flatId, super.triggeredBy, super.timestamp, super.location, super.status, super.resolvedBy, super.resolvedAt, super.societyId, super.createdAt});
  factory PanicAlertModel.fromJson(Map<String, dynamic> j) => PanicAlertModel(id: j['id'] as String, flatId: j['flatId'] as String?, triggeredBy: j['triggeredBy'] as String?, timestamp: j['timestamp'] != null ? DateTime.parse(j['timestamp'] as String) : null, location: j['location'] as String?, status: j['status'] as String?, resolvedBy: j['resolvedBy'] as String?, resolvedAt: j['resolvedAt'] != null ? DateTime.parse(j['resolvedAt'] as String) : null, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class EmergencyContactModel extends EmergencyContactEntity {
  const EmergencyContactModel({required super.id, required super.name, required super.phone, required super.type, super.address, super.societyId, super.createdAt});
  factory EmergencyContactModel.fromJson(Map<String, dynamic> j) => EmergencyContactModel(id: j['id'] as String, name: j['name'] as String, phone: j['phone'] as String, type: j['type'] as String, address: j['address'] as String?, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

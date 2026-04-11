import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart';

class GatepassModel extends GatepassEntity {
  const GatepassModel({required super.id, required super.type, required super.description, required super.status, super.items, super.vehicleNumber, super.expectedDate, super.requestedBy, super.flatId, super.approvedBy, super.verifiedBy, super.verifiedAt, super.societyId, super.createdAt});
  factory GatepassModel.fromJson(Map<String, dynamic> j) => GatepassModel(id: j['id'] as String, type: j['type'] as String, description: j['description'] as String, status: j['status'] as String, items: (j['items'] as List<dynamic>?)?.cast<String>(), vehicleNumber: j['vehicleNumber'] as String?, expectedDate: j['expectedDate'] as String?, requestedBy: j['requestedBy'] as String?, flatId: j['flatId'] as String?, approvedBy: j['approvedBy'] as String?, verifiedBy: j['verifiedBy'] as String?, verifiedAt: j['verifiedAt'] != null ? DateTime.parse(j['verifiedAt'] as String) : null, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

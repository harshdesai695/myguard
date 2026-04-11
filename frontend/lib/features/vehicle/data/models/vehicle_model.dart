import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  const VehicleModel({required super.id, required super.plateNumber, required super.type, super.make, super.model, super.colour, super.ownerUid, super.flatId, super.parkingSlotId, super.societyId, super.createdAt});
  factory VehicleModel.fromJson(Map<String, dynamic> j) => VehicleModel(id: j['id'] as String, plateNumber: j['plateNumber'] as String, type: j['type'] as String, make: j['make'] as String?, model: j['model'] as String?, colour: j['colour'] as String?, ownerUid: j['ownerUid'] as String?, flatId: j['flatId'] as String?, parkingSlotId: j['parkingSlotId'] as String?, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

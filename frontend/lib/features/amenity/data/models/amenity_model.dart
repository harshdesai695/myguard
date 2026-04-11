import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';

class AmenityModel extends AmenityEntity {
  const AmenityModel({required super.id, required super.name, required super.type, super.capacity, super.pricing, super.operatingHours, super.coolDownMinutes, super.maintenanceClosureDates, super.societyId, super.status, super.createdAt});
  factory AmenityModel.fromJson(Map<String, dynamic> j) => AmenityModel(id: j['id'] as String, name: j['name'] as String, type: j['type'] as String, capacity: j['capacity'] as int?, pricing: j['pricing'] as Map<String, dynamic>?, operatingHours: j['operatingHours'] as Map<String, dynamic>?, coolDownMinutes: j['coolDownMinutes'] as int?, maintenanceClosureDates: (j['maintenanceClosureDates'] as List<dynamic>?)?.cast<String>(), societyId: j['societyId'] as String?, status: j['status'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class BookingModel extends BookingEntity {
  const BookingModel({required super.id, required super.amenityId, required super.residentUid, required super.slotDate, required super.startTime, required super.endTime, required super.status, super.flatId, super.notes, super.checkedInAt, super.checkedOutAt, super.societyId, super.createdAt});
  factory BookingModel.fromJson(Map<String, dynamic> j) => BookingModel(id: j['id'] as String, amenityId: j['amenityId'] as String, residentUid: j['residentUid'] as String, slotDate: j['slotDate'] as String, startTime: j['startTime'] as String, endTime: j['endTime'] as String, status: j['status'] as String, flatId: j['flatId'] as String?, notes: j['notes'] as String?, checkedInAt: j['checkedInAt'] != null ? DateTime.parse(j['checkedInAt'] as String) : null, checkedOutAt: j['checkedOutAt'] != null ? DateTime.parse(j['checkedOutAt'] as String) : null, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

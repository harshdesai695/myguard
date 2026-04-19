import 'package:myguard_frontend/features/amenity/domain/entities/amenity_entity.dart';

class AmenityModel extends AmenityEntity {
  const AmenityModel({required super.id, required super.name, required super.type, super.capacity, super.pricing, super.operatingHours, super.coolDownMinutes, super.maintenanceClosureDates, super.societyId, super.status, super.createdAt});
  factory AmenityModel.fromJson(Map<String, dynamic> j) => AmenityModel(
    id: j['id'] as String? ?? '',
    name: j['name'] as String? ?? '',
    type: j['type'] as String? ?? '',
    capacity: j['capacity'] as int?,
    pricing: j['pricing'] is Map ? j['pricing'] as Map<String, dynamic> : null,
    operatingHours: j['operatingHours'] is Map ? j['operatingHours'] as Map<String, dynamic> : null,
    coolDownMinutes: j['coolDownMinutes'] as int?,
    maintenanceClosureDates: (j['maintenanceClosureDates'] as List<dynamic>?)?.cast<String>(),
    societyId: j['societyId'] as String?,
    status: j['status'] as String?,
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt'].toString()) : null,
  );
}

class BookingModel extends BookingEntity {
  const BookingModel({required super.id, super.amenityId, super.residentUid, super.slotDate, super.startTime, super.endTime, super.status, super.flatId, super.notes, super.checkedInAt, super.checkedOutAt, super.societyId, super.createdAt, super.companions});
  factory BookingModel.fromJson(Map<String, dynamic> j) => BookingModel(
    id: j['id'] as String? ?? '',
    amenityId: j['amenityId'] as String? ?? '',
    residentUid: j['residentUid'] as String? ?? '',
    slotDate: j['slotDate'] as String? ?? '',
    startTime: j['startTime'] as String? ?? '',
    endTime: j['endTime'] as String? ?? '',
    status: j['status'] as String? ?? '',
    flatId: j['flatId'] as String?,
    notes: j['notes'] as String?,
    companions: j['companions'] as int? ?? 0,
    checkedInAt: j['checkedInAt'] != null ? DateTime.tryParse(j['checkedInAt'].toString()) : null,
    checkedOutAt: j['checkedOutAt'] != null ? DateTime.tryParse(j['checkedOutAt'].toString()) : null,
    societyId: j['societyId'] as String?,
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt'].toString()) : null,
  );
}

import 'package:equatable/equatable.dart';

class AmenityEntity extends Equatable {
  const AmenityEntity({required this.id, required this.name, required this.type, this.capacity, this.pricing, this.operatingHours, this.coolDownMinutes, this.maintenanceClosureDates, this.societyId, this.status, this.createdAt});
  final String id; final String name; final String type; final int? capacity; final Map<String, dynamic>? pricing; final Map<String, dynamic>? operatingHours; final int? coolDownMinutes; final List<String>? maintenanceClosureDates; final String? societyId; final String? status; final DateTime? createdAt;
  @override List<Object?> get props => [id, name, type];
}

class BookingEntity extends Equatable {
  const BookingEntity({required this.id, this.amenityId = '', this.residentUid = '', this.slotDate = '', this.startTime = '', this.endTime = '', this.status = '', this.flatId, this.notes, this.checkedInAt, this.checkedOutAt, this.societyId, this.createdAt, this.companions = 0});
  final String id; final String amenityId; final String residentUid; final String slotDate; final String startTime; final String endTime; final String status; final String? flatId; final String? notes; final DateTime? checkedInAt; final DateTime? checkedOutAt; final String? societyId; final DateTime? createdAt; final int companions;
  @override List<Object?> get props => [id, amenityId, status];
}

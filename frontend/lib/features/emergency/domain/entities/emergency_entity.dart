import 'package:equatable/equatable.dart';

class PanicAlertEntity extends Equatable {
  const PanicAlertEntity({required this.id, this.flatId, this.triggeredBy, this.timestamp, this.location, this.status, this.resolvedBy, this.resolvedAt, this.societyId, this.createdAt});
  final String id; final String? flatId; final String? triggeredBy; final DateTime? timestamp; final String? location; final String? status; final String? resolvedBy; final DateTime? resolvedAt; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, status];
}

class EmergencyContactEntity extends Equatable {
  const EmergencyContactEntity({required this.id, required this.name, required this.phone, required this.type, this.address, this.societyId, this.createdAt});
  final String id; final String name; final String phone; final String type; final String? address; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, name, type];
}

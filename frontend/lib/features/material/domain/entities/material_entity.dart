import 'package:equatable/equatable.dart';

class GatepassEntity extends Equatable {
  const GatepassEntity({required this.id, required this.type, required this.description, required this.status, this.items, this.vehicleNumber, this.expectedDate, this.requestedBy, this.flatId, this.approvedBy, this.verifiedBy, this.verifiedAt, this.societyId, this.createdAt});
  final String id; final String type; final String description; final String status; final List<String>? items; final String? vehicleNumber; final String? expectedDate; final String? requestedBy; final String? flatId; final String? approvedBy; final String? verifiedBy; final DateTime? verifiedAt; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, type, status];
}

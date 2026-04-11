import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  const VehicleEntity({required this.id, required this.plateNumber, required this.type, this.make, this.model, this.colour, this.ownerUid, this.flatId, this.parkingSlotId, this.societyId, this.createdAt});
  final String id; final String plateNumber; final String type; final String? make; final String? model; final String? colour; final String? ownerUid; final String? flatId; final String? parkingSlotId; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, plateNumber];
}

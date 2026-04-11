import 'package:equatable/equatable.dart';

class SocietyEntity extends Equatable {
  const SocietyEntity({required this.id, required this.name, required this.address, this.city, this.state, this.pincode, this.totalBlocks, this.totalFlats, this.logoUrl, this.status, this.createdAt, this.updatedAt});
  final String id; final String name; final String address; final String? city; final String? state; final String? pincode; final int? totalBlocks; final int? totalFlats; final String? logoUrl; final String? status; final DateTime? createdAt; final DateTime? updatedAt;
  @override List<Object?> get props => [id, name];
}

class FlatEntity extends Equatable {
  const FlatEntity({required this.id, required this.societyId, required this.block, required this.flatNumber, this.flatType, this.area, this.primaryResidentUid, this.status, this.createdAt});
  final String id; final String societyId; final String block; final String flatNumber; final String? flatType; final double? area; final String? primaryResidentUid; final String? status; final DateTime? createdAt;
  @override List<Object?> get props => [id, flatNumber];
}

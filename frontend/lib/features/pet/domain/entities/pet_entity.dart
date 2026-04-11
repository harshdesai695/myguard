import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  const PetEntity({required this.id, required this.name, required this.type, this.breed, this.age, this.photoUrl, this.ownerUid, this.flatId, this.vaccinationStatus, this.societyId, this.createdAt});
  final String id; final String name; final String type; final String? breed; final int? age; final String? photoUrl; final String? ownerUid; final String? flatId; final String? vaccinationStatus; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, name, type];
}

class VaccinationEntity extends Equatable {
  const VaccinationEntity({required this.id, required this.petId, required this.vaccineName, this.vaccinationDate, this.nextDueDate, this.veterinarianName, this.createdAt});
  final String id; final String petId; final String vaccineName; final DateTime? vaccinationDate; final DateTime? nextDueDate; final String? veterinarianName; final DateTime? createdAt;
  @override List<Object?> get props => [id, petId, vaccineName];
}

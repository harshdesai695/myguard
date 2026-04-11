import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  const PetModel({required super.id, required super.name, required super.type, super.breed, super.age, super.photoUrl, super.ownerUid, super.flatId, super.vaccinationStatus, super.societyId, super.createdAt});
  factory PetModel.fromJson(Map<String, dynamic> j) => PetModel(id: j['id'] as String, name: j['name'] as String, type: j['type'] as String, breed: j['breed'] as String?, age: j['age'] as int?, photoUrl: j['photoUrl'] as String?, ownerUid: j['ownerUid'] as String?, flatId: j['flatId'] as String?, vaccinationStatus: j['vaccinationStatus'] as String?, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class VaccinationModel extends VaccinationEntity {
  const VaccinationModel({required super.id, required super.petId, required super.vaccineName, super.vaccinationDate, super.nextDueDate, super.veterinarianName, super.createdAt});
  factory VaccinationModel.fromJson(Map<String, dynamic> j) => VaccinationModel(id: j['id'] as String, petId: j['petId'] as String, vaccineName: j['vaccineName'] as String, vaccinationDate: j['vaccinationDate'] != null ? DateTime.parse(j['vaccinationDate'] as String) : null, nextDueDate: j['nextDueDate'] != null ? DateTime.parse(j['nextDueDate'] as String) : null, veterinarianName: j['veterinarianName'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

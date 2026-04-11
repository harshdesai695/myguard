import 'package:myguard_frontend/core/network/dio_client.dart'; import 'package:myguard_frontend/core/network/paginated_response_model.dart'; import 'package:myguard_frontend/features/pet/data/models/pet_model.dart';

abstract class PetRemoteDatasource { Future<PaginatedResponseModel<PetModel>> getPets({int page, int size, String? societyId}); Future<PetModel> getPetById(String id); Future<PetModel> registerPet(Map<String, dynamic> data); Future<PetModel> updatePet(String id, Map<String, dynamic> data); Future<void> deletePet(String id); Future<VaccinationModel> addVaccination(String petId, Map<String, dynamic> data); Future<List<VaccinationModel>> getVaccinations(String petId); }

class PetRemoteDatasourceImpl implements PetRemoteDatasource {
  const PetRemoteDatasourceImpl({required this.dioClient}); final DioClient dioClient;
  @override Future<PaginatedResponseModel<PetModel>> getPets({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/pets', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => PetModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<PetModel> getPetById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/pets/$id'); return PetModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PetModel> registerPet(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/pets', data: data); return PetModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PetModel> updatePet(String id, Map<String, dynamic> data) async { final r = await dioClient.put<Map<String, dynamic>>('/pets/$id', data: data); return PetModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> deletePet(String id) async => dioClient.delete<void>('/pets/$id');
  @override Future<VaccinationModel> addVaccination(String petId, Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/pets/$petId/vaccinations', data: data); return VaccinationModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<List<VaccinationModel>> getVaccinations(String petId) async { final r = await dioClient.get<Map<String, dynamic>>('/pets/$petId/vaccinations'); final list = r.data!['data'] as List<dynamic>; return list.map((j) => VaccinationModel.fromJson(j as Map<String, dynamic>)).toList(); }
}

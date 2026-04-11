import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/vehicle/data/models/vehicle_model.dart';

abstract class VehicleRemoteDatasource {
  Future<PaginatedResponseModel<VehicleModel>> getVehicles({int page, int size});
  Future<VehicleModel> getVehicleById(String id);
  Future<VehicleModel> registerVehicle(Map<String, dynamic> data);
  Future<VehicleModel> updateVehicle(String id, Map<String, dynamic> data);
  Future<void> deleteVehicle(String id);
  Future<VehicleModel> lookupByPlate(String plateNumber);
}

class VehicleRemoteDatasourceImpl implements VehicleRemoteDatasource {
  const VehicleRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;
  @override Future<PaginatedResponseModel<VehicleModel>> getVehicles({int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/vehicles', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => VehicleModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<VehicleModel> getVehicleById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/vehicles/$id'); return VehicleModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<VehicleModel> registerVehicle(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/vehicles', data: data); return VehicleModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<VehicleModel> updateVehicle(String id, Map<String, dynamic> data) async { final r = await dioClient.put<Map<String, dynamic>>('/vehicles/$id', data: data); return VehicleModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> deleteVehicle(String id) async => dioClient.delete<void>('/vehicles/$id');
  @override Future<VehicleModel> lookupByPlate(String plateNumber) async { final r = await dioClient.get<Map<String, dynamic>>('/vehicles/lookup/$plateNumber'); return VehicleModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
}

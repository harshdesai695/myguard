import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/material/data/models/material_model.dart';

abstract class MaterialRemoteDatasource {
  Future<PaginatedResponseModel<GatepassModel>> getGatepasses({int page, int size});
  Future<GatepassModel> getGatepassById(String id);
  Future<GatepassModel> createGatepass(Map<String, dynamic> data);
  Future<GatepassModel> approveGatepass(String id);
  Future<GatepassModel> verifyGatepass(String id);
  Future<PaginatedResponseModel<GatepassModel>> getAdminGatepasses({int page, int size});
}

class MaterialRemoteDatasourceImpl implements MaterialRemoteDatasource {
  const MaterialRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;
  @override Future<PaginatedResponseModel<GatepassModel>> getGatepasses({int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/material-gatepasses', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => GatepassModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<GatepassModel> getGatepassById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/material-gatepasses/$id'); return GatepassModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<GatepassModel> createGatepass(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/material-gatepasses', data: data); return GatepassModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<GatepassModel> approveGatepass(String id) async { final r = await dioClient.patch<Map<String, dynamic>>('/material-gatepasses/$id/approve'); return GatepassModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<GatepassModel> verifyGatepass(String id) async { final r = await dioClient.patch<Map<String, dynamic>>('/material-gatepasses/$id/verify'); return GatepassModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<GatepassModel>> getAdminGatepasses({int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/material-gatepasses/admin', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => GatepassModel.fromJson(j! as Map<String, dynamic>)); }
}

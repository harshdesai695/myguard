import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/guard/data/models/guard_model.dart';

abstract class GuardRemoteDatasource {
  Future<PaginatedResponseModel<CheckpointModel>> getCheckpoints({int page, int size});
  Future<PatrolModel> logPatrol(Map<String, dynamic> data);
  Future<PaginatedResponseModel<PatrolModel>> getPatrols({int page, int size, String? guardUid});
  Future<PaginatedResponseModel<ShiftModel>> getShifts({int page, int size});
  Future<ShiftModel> createShift(Map<String, dynamic> data);
  Future<void> sendIntercom(String flatId, Map<String, dynamic> data);
}

class GuardRemoteDatasourceImpl implements GuardRemoteDatasource {
  const GuardRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<PaginatedResponseModel<CheckpointModel>> getCheckpoints({int page = 0, int size = 20}) async {
    final r = await dioClient.get<Map<String, dynamic>>('/guards/patrols/checkpoints', queryParameters: {'page': page, 'size': size});
    return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => CheckpointModel.fromJson(j! as Map<String, dynamic>));
  }

  @override
  Future<PatrolModel> logPatrol(Map<String, dynamic> data) async {
    final r = await dioClient.post<Map<String, dynamic>>('/guards/patrols', data: data);
    return PatrolModel.fromJson(r.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResponseModel<PatrolModel>> getPatrols({int page = 0, int size = 20, String? guardUid}) async {
    final r = await dioClient.get<Map<String, dynamic>>('/guards/patrols', queryParameters: {'page': page, 'size': size, if (guardUid != null) 'guardUid': guardUid});
    return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => PatrolModel.fromJson(j! as Map<String, dynamic>));
  }

  @override
  Future<PaginatedResponseModel<ShiftModel>> getShifts({int page = 0, int size = 20}) async {
    final r = await dioClient.get<Map<String, dynamic>>('/guards/shifts', queryParameters: {'page': page, 'size': size});
    return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => ShiftModel.fromJson(j! as Map<String, dynamic>));
  }

  @override
  Future<ShiftModel> createShift(Map<String, dynamic> data) async {
    final r = await dioClient.post<Map<String, dynamic>>('/guards/shifts', data: data);
    return ShiftModel.fromJson(r.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> sendIntercom(String flatId, Map<String, dynamic> data) async {
    await dioClient.post<void>('/guards/e-intercom/$flatId', data: data);
  }
}

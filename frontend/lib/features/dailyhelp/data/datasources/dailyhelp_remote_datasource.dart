import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/dailyhelp/data/models/dailyhelp_model.dart';

abstract class DailyHelpRemoteDatasource {
  Future<PaginatedResponseModel<DailyHelpModel>> getDailyHelps({int page, int size});
  Future<DailyHelpModel> getDailyHelpById(String id);
  Future<DailyHelpModel> createDailyHelp(Map<String, dynamic> data);
  Future<DailyHelpModel> updateDailyHelp(String id, Map<String, dynamic> data);
  Future<void> deleteDailyHelp(String id);
  Future<AttendanceModel> markAttendance(String dailyHelpId);
  Future<PaginatedResponseModel<AttendanceModel>> getAttendance(String id, {int page, int size});
}

class DailyHelpRemoteDatasourceImpl implements DailyHelpRemoteDatasource {
  const DailyHelpRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<PaginatedResponseModel<DailyHelpModel>> getDailyHelps({int page = 0, int size = 20}) async {
    final response = await dioClient.get<Map<String, dynamic>>('/daily-helps', queryParameters: {'page': page, 'size': size});
    return PaginatedResponseModel.fromJson(response.data!['data'] as Map<String, dynamic>, (json) => DailyHelpModel.fromJson(json! as Map<String, dynamic>));
  }

  @override
  Future<DailyHelpModel> getDailyHelpById(String id) async {
    final response = await dioClient.get<Map<String, dynamic>>('/daily-helps/$id');
    return DailyHelpModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<DailyHelpModel> createDailyHelp(Map<String, dynamic> data) async {
    final response = await dioClient.post<Map<String, dynamic>>('/daily-helps', data: data);
    return DailyHelpModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<DailyHelpModel> updateDailyHelp(String id, Map<String, dynamic> data) async {
    final response = await dioClient.put<Map<String, dynamic>>('/daily-helps/$id', data: data);
    return DailyHelpModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteDailyHelp(String id) async => dioClient.delete<void>('/daily-helps/$id');

  @override
  Future<AttendanceModel> markAttendance(String dailyHelpId) async {
    final response = await dioClient.post<Map<String, dynamic>>('/daily-helps/$dailyHelpId/attendance');
    return AttendanceModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResponseModel<AttendanceModel>> getAttendance(String id, {int page = 0, int size = 20}) async {
    final response = await dioClient.get<Map<String, dynamic>>('/daily-helps/$id/attendance', queryParameters: {'page': page, 'size': size});
    return PaginatedResponseModel.fromJson(response.data!['data'] as Map<String, dynamic>, (json) => AttendanceModel.fromJson(json! as Map<String, dynamic>));
  }
}

import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardRemoteDatasource { Future<DashboardSummaryModel> getDashboardSummary(String societyId); }

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  const DashboardRemoteDatasourceImpl({required this.dioClient}); final DioClient dioClient;
  @override Future<DashboardSummaryModel> getDashboardSummary(String societyId) async { final r = await dioClient.get<Map<String, dynamic>>('/dashboard/summary', queryParameters: {'societyId': societyId}); return DashboardSummaryModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
}

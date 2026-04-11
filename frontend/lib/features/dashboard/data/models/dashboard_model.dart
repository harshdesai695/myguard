import 'package:myguard_frontend/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({super.totalResidents, super.totalGuards, super.totalVisitors, super.totalVehicles, super.totalComplaints});
  factory DashboardSummaryModel.fromJson(Map<String, dynamic> j) => DashboardSummaryModel(totalResidents: j['totalResidents'] as int? ?? 0, totalGuards: j['totalGuards'] as int? ?? 0, totalVisitors: j['totalVisitors'] as int? ?? 0, totalVehicles: j['totalVehicles'] as int? ?? 0, totalComplaints: j['totalComplaints'] as int? ?? 0);
}

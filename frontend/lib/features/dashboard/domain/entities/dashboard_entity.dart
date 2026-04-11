import 'package:equatable/equatable.dart';

class DashboardSummaryEntity extends Equatable {
  const DashboardSummaryEntity({this.totalResidents = 0, this.totalGuards = 0, this.totalVisitors = 0, this.totalVehicles = 0, this.totalComplaints = 0});
  final int totalResidents; final int totalGuards; final int totalVisitors; final int totalVehicles; final int totalComplaints;
  @override List<Object> get props => [totalResidents, totalGuards, totalVisitors, totalVehicles, totalComplaints];
}

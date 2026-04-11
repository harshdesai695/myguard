import 'package:dartz/dartz.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary(String societyId);
}

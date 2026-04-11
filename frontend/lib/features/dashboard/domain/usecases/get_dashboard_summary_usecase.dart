import 'package:dartz/dartz.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/features/dashboard/domain/entities/dashboard_entity.dart'; import 'package:myguard_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardSummaryUseCase { const GetDashboardSummaryUseCase({required this.repository}); final DashboardRepository repository; Future<Either<Failure, DashboardSummaryEntity>> call(String societyId) => repository.getDashboardSummary(societyId); }

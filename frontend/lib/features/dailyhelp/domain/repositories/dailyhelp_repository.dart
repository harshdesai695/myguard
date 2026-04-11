import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';

abstract class DailyHelpRepository {
  Future<Either<Failure, PaginatedResponseModel<DailyHelpEntity>>> getDailyHelps({int page, int size});
  Future<Either<Failure, DailyHelpEntity>> getDailyHelpById(String id);
  Future<Either<Failure, DailyHelpEntity>> createDailyHelp(Map<String, dynamic> data);
  Future<Either<Failure, DailyHelpEntity>> updateDailyHelp(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteDailyHelp(String id);
  Future<Either<Failure, AttendanceEntity>> markAttendance(String dailyHelpId);
  Future<Either<Failure, PaginatedResponseModel<AttendanceEntity>>> getAttendance(String dailyHelpId, {int page, int size});
}

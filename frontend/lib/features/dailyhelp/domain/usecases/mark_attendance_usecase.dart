import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';

class MarkAttendanceUseCase {
  const MarkAttendanceUseCase({required this.repository});
  final DailyHelpRepository repository;
  Future<Either<Failure, AttendanceEntity>> call(String dailyHelpId) =>
      repository.markAttendance(dailyHelpId);
}

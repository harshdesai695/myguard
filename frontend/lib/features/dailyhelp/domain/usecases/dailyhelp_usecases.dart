import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';

class CreateDailyHelpUseCase {
  const CreateDailyHelpUseCase({required this.repository});
  final DailyHelpRepository repository;
  Future<Either<Failure, DailyHelpEntity>> call(Map<String, dynamic> data) => repository.createDailyHelp(data);
}

class UpdateDailyHelpUseCase {
  const UpdateDailyHelpUseCase({required this.repository});
  final DailyHelpRepository repository;
  Future<Either<Failure, DailyHelpEntity>> call(String id, Map<String, dynamic> data) => repository.updateDailyHelp(id, data);
}

class DeleteDailyHelpUseCase {
  const DeleteDailyHelpUseCase({required this.repository});
  final DailyHelpRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deleteDailyHelp(id);
}

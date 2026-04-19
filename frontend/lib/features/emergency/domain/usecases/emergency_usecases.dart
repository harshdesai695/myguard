import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart';
import 'package:myguard_frontend/features/emergency/domain/repositories/emergency_repository.dart';

class GetPanicAlertsUseCase {
  const GetPanicAlertsUseCase({required this.repository});
  final EmergencyRepository repository;
  Future<Either<Failure, PaginatedResponseModel<PanicAlertEntity>>> call({int page = 0, int size = 20, String? societyId}) =>
      repository.getPanicAlerts(page: page, size: size, societyId: societyId);
}

class ResolvePanicUseCase {
  const ResolvePanicUseCase({required this.repository});
  final EmergencyRepository repository;
  Future<Either<Failure, PanicAlertEntity>> call(String id) => repository.resolvePanic(id);
}

class CreateEmergencyContactUseCase {
  const CreateEmergencyContactUseCase({required this.repository});
  final EmergencyRepository repository;
  Future<Either<Failure, EmergencyContactEntity>> call(Map<String, dynamic> data) => repository.createContact(data);
}

class UpdateEmergencyContactUseCase {
  const UpdateEmergencyContactUseCase({required this.repository});
  final EmergencyRepository repository;
  Future<Either<Failure, EmergencyContactEntity>> call(String id, Map<String, dynamic> data) =>
      repository.updateContact(id, data);
}

class DeleteEmergencyContactUseCase {
  const DeleteEmergencyContactUseCase({required this.repository});
  final EmergencyRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deleteContact(id);
}

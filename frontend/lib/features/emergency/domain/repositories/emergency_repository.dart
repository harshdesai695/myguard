import 'package:dartz/dartz.dart'; import 'package:myguard_frontend/core/error/failures.dart'; import 'package:myguard_frontend/core/network/paginated_response_model.dart'; import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart';

abstract class EmergencyRepository {
  Future<Either<Failure, PanicAlertEntity>> triggerPanic(Map<String, dynamic> data);
  Future<Either<Failure, PaginatedResponseModel<PanicAlertEntity>>> getPanicAlerts({int page, int size, String? societyId});
  Future<Either<Failure, PanicAlertEntity>> resolvePanic(String id);
  Future<Either<Failure, PaginatedResponseModel<EmergencyContactEntity>>> getEmergencyContacts({int page, int size, String? societyId});
  Future<Either<Failure, EmergencyContactEntity>> createContact(Map<String, dynamic> data);
  Future<Either<Failure, EmergencyContactEntity>> updateContact(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteContact(String id);
}

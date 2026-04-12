import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart';
import 'package:myguard_frontend/features/emergency/domain/repositories/emergency_repository.dart';

class TriggerPanicUseCase { const TriggerPanicUseCase({required this.repository}); final EmergencyRepository repository; Future<Either<Failure, PanicAlertEntity>> call(Map<String, dynamic> data) => repository.triggerPanic(data); }

import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call() {
    return repository.getProfile();
  }
}

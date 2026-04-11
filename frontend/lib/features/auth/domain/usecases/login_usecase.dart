import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}

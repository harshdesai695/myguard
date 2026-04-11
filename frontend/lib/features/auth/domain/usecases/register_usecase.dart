import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? societyId,
    String? flatNumber,
    String? flatId,
    String? profilePhotoUrl,
  }) {
    return repository.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
      societyId: societyId,
      flatNumber: flatNumber,
      flatId: flatId,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}

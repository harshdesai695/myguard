import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, PaginatedResponseModel<UserEntity>>> call({
    int page = 0,
    int size = 20,
    String? role,
  }) {
    return repository.getUsers(page: page, size: size, role: role);
  }
}

class GetUserByIdUseCase {
  const GetUserByIdUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call(String uid) {
    return repository.getUserById(uid);
  }
}

class ChangeUserRoleUseCase {
  const ChangeUserRoleUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call(String uid, String role) {
    return repository.changeUserRole(uid, role);
  }
}

class ChangeUserStatusUseCase {
  const ChangeUserStatusUseCase({required this.repository});
  final AuthRepository repository;

  Future<Either<Failure, UserEntity>> call(String uid, String status) {
    return repository.changeUserStatus(uid, status);
  }
}

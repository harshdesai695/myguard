import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? societyId,
    String? flatNumber,
    String? flatId,
    String? profilePhotoUrl,
  });

  Future<Either<Failure, UserEntity>> getProfile();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? phone,
    String? profilePhotoUrl,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> signOut();

  // Admin user management
  Future<Either<Failure, PaginatedResponseModel<UserEntity>>> getUsers({
    int page = 0,
    int size = 20,
    String? role,
  });

  Future<Either<Failure, UserEntity>> getUserById(String uid);

  Future<Either<Failure, UserEntity>> changeUserRole(String uid, String role);

  Future<Either<Failure, UserEntity>> changeUserStatus(String uid, String status);
}

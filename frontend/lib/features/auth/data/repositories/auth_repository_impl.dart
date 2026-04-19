import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/firebase/auth_service.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:myguard_frontend/features/auth/data/models/user_model.dart';
import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';
import 'package:myguard_frontend/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.authService,
  });

  final AuthRemoteDatasource remoteDatasource;
  final AuthService authService;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await remoteDatasource.getProfile();
      return Right(user);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final request = RegisterRequestModel(
        name: name,
        email: email,
        phone: phone,
        role: role,
        societyId: societyId,
        flatNumber: flatNumber,
        flatId: flatId,
        profilePhotoUrl: profilePhotoUrl,
      );
      final user = await remoteDatasource.register(request);
      return Right(user);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await remoteDatasource.getProfile();
      return Right(user);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? phone,
    String? profilePhotoUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      };
      final user = await remoteDatasource.updateProfile(data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await authService.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<UserEntity>>> getUsers({
    int page = 0,
    int size = 20,
    String? role,
  }) async {
    try {
      final result = await remoteDatasource.getUsers(page: page, size: size, role: role);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String uid) async {
    try {
      final result = await remoteDatasource.getUserById(uid);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> changeUserRole(String uid, String role) async {
    try {
      final result = await remoteDatasource.changeUserRole(uid, role);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> changeUserStatus(String uid, String status) async {
    try {
      final result = await remoteDatasource.changeUserStatus(uid, status);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    final error = e.error;
    if (error is NetworkException) return const NetworkFailure();
    if (error is UnauthorizedException) return const UnauthorizedFailure();
    if (error is NotFoundException) return const NotFoundFailure();
    if (error is ServerException) return ServerFailure(error.message ?? 'Server error');
    return const UnknownFailure();
  }
}

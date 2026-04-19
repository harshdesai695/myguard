import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  /// POST /api/v1/auth/register
  Future<UserModel> register(RegisterRequestModel request);

  /// GET /api/v1/auth/profile
  Future<UserModel> getProfile();

  /// PUT /api/v1/auth/profile
  Future<UserModel> updateProfile(Map<String, dynamic> data);

  /// GET /api/v1/auth/users?page&size&role (ADMIN)
  Future<PaginatedResponseModel<UserModel>> getUsers({int page = 0, int size = 20, String? role});

  /// GET /api/v1/auth/users/{uid} (ADMIN)
  Future<UserModel> getUserById(String uid);

  /// PATCH /api/v1/auth/users/{uid}/role (ADMIN)
  Future<UserModel> changeUserRole(String uid, String role);

  /// PATCH /api/v1/auth/users/{uid}/status (ADMIN)
  Future<UserModel> changeUserStatus(String uid, String status);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<UserModel> register(RegisterRequestModel request) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: request.toJson(),
    );
    final data = response.data!;
    final responseData = data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(responseData);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/auth/profile',
    );
    final data = response.data!;
    final responseData = data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(responseData);
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await dioClient.put<Map<String, dynamic>>(
      '/auth/profile',
      data: data,
    );
    final responseData = response.data!;
    final result = responseData['data'] as Map<String, dynamic>;
    return UserModel.fromJson(result);
  }

  @override
  Future<PaginatedResponseModel<UserModel>> getUsers({int page = 0, int size = 20, String? role}) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/auth/users',
      queryParameters: {'page': page, 'size': size, if (role != null) 'role': role},
    );
    return PaginatedResponseModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
      (json) => UserModel.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<UserModel> getUserById(String uid) async {
    final response = await dioClient.get<Map<String, dynamic>>('/auth/users/$uid');
    return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> changeUserRole(String uid, String role) async {
    final response = await dioClient.patch<Map<String, dynamic>>(
      '/auth/users/$uid/role',
      data: {'role': role},
    );
    return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> changeUserStatus(String uid, String status) async {
    final response = await dioClient.patch<Map<String, dynamic>>(
      '/auth/users/$uid/status',
      data: {'status': status},
    );
    return UserModel.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}

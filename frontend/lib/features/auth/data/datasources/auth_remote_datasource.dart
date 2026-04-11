import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  /// POST /api/v1/auth/register
  Future<UserModel> register(RegisterRequestModel request);

  /// GET /api/v1/auth/profile
  Future<UserModel> getProfile();

  /// PUT /api/v1/auth/profile
  Future<UserModel> updateProfile(Map<String, dynamic> data);
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
}

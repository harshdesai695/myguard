import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/visitor/data/models/visitor_model.dart';

abstract class VisitorRemoteDatasource {
  Future<PaginatedResponseModel<VisitorModel>> getVisitors({
    int page = 0,
    int size = 20,
    String? flatId,
    String? status,
    String? from,
    String? to,
  });

  Future<VisitorModel> getVisitorById(String id);

  Future<PreApprovalModel> preApproveVisitor(Map<String, dynamic> data);

  Future<PaginatedResponseModel<PreApprovalModel>> getPreApprovals({
    int page = 0,
    int size = 20,
  });

  Future<void> deletePreApproval(String id);

  Future<VisitorModel> approveVisitor(String id);
  Future<VisitorModel> rejectVisitor(String id);
  Future<VisitorModel> logEntry(Map<String, dynamic> data);
  Future<VisitorModel> markExit(String id);
  Future<PreApprovalModel> verifyCode(String code);
  Future<PreApprovalModel> createGuestInvite(Map<String, dynamic> data);
}

class VisitorRemoteDatasourceImpl implements VisitorRemoteDatasource {
  const VisitorRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<PaginatedResponseModel<VisitorModel>> getVisitors({
    int page = 0,
    int size = 20,
    String? flatId,
    String? status,
    String? from,
    String? to,
  }) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/visitors',
      queryParameters: {
        'page': page,
        'size': size,
        if (flatId != null) 'flatId': flatId,
        if (status != null) 'status': status,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return PaginatedResponseModel.fromJson(
      data,
      (json) => VisitorModel.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<VisitorModel> getVisitorById(String id) async {
    final response = await dioClient.get<Map<String, dynamic>>('/visitors/$id');
    return VisitorModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PreApprovalModel> preApproveVisitor(Map<String, dynamic> data) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/visitors/pre-approve',
      data: data,
    );
    return PreApprovalModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PaginatedResponseModel<PreApprovalModel>> getPreApprovals({
    int page = 0,
    int size = 20,
  }) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/visitors/pre-approvals',
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return PaginatedResponseModel.fromJson(
      data,
      (json) => PreApprovalModel.fromJson(json! as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deletePreApproval(String id) async {
    await dioClient.delete<void>('/visitors/pre-approvals/$id');
  }

  @override
  Future<VisitorModel> approveVisitor(String id) async {
    final response = await dioClient.patch<Map<String, dynamic>>(
      '/visitors/entry/$id/approve',
    );
    return VisitorModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<VisitorModel> rejectVisitor(String id) async {
    final response = await dioClient.patch<Map<String, dynamic>>(
      '/visitors/entry/$id/reject',
    );
    return VisitorModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<VisitorModel> logEntry(Map<String, dynamic> data) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/visitors/entry',
      data: data,
    );
    return VisitorModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<VisitorModel> markExit(String id) async {
    final response = await dioClient.patch<Map<String, dynamic>>(
      '/visitors/entry/$id/exit',
    );
    return VisitorModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PreApprovalModel> verifyCode(String code) async {
    final response = await dioClient.get<Map<String, dynamic>>(
      '/visitors/verify/$code',
    );
    return PreApprovalModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PreApprovalModel> createGuestInvite(Map<String, dynamic> data) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      '/visitors/guest-invite',
      data: data,
    );
    return PreApprovalModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}

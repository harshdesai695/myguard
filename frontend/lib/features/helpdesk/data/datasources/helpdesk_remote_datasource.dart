import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/helpdesk/data/models/helpdesk_model.dart';

abstract class HelpdeskRemoteDatasource {
  Future<PaginatedResponseModel<TicketModel>> getTickets({int page, int size, String? status});
  Future<TicketModel> getTicketById(String id);
  Future<TicketModel> createTicket(Map<String, dynamic> data);
  Future<TicketModel> updateTicketStatus(String id, String status);
  Future<CommentModel> addComment(String ticketId, Map<String, dynamic> data);
  Future<TicketModel> rateTicket(String id, Map<String, dynamic> data);
}

class HelpdeskRemoteDatasourceImpl implements HelpdeskRemoteDatasource {
  const HelpdeskRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override Future<PaginatedResponseModel<TicketModel>> getTickets({int page = 0, int size = 20, String? status}) async { final r = await dioClient.get<Map<String, dynamic>>('/helpdesk/tickets', queryParameters: {'page': page, 'size': size, if (status != null) 'status': status}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => TicketModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<TicketModel> getTicketById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/helpdesk/tickets/$id'); return TicketModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<TicketModel> createTicket(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/helpdesk/tickets', data: data); return TicketModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<TicketModel> updateTicketStatus(String id, String status) async { final r = await dioClient.patch<Map<String, dynamic>>('/helpdesk/tickets/$id/status', data: {'status': status}); return TicketModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<CommentModel> addComment(String ticketId, Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/helpdesk/tickets/$ticketId/comment', data: data); return CommentModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<TicketModel> rateTicket(String id, Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/helpdesk/tickets/$id/rate', data: data); return TicketModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
}

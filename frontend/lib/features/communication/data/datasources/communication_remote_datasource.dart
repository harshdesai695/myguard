import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/communication/data/models/communication_model.dart';

abstract class CommunicationRemoteDatasource {
  Future<PaginatedResponseModel<NoticeModel>> getNotices({int page, int size, String? societyId});
  Future<NoticeModel> getNoticeById(String id);
  Future<NoticeModel> createNotice(Map<String, dynamic> data);
  Future<void> deleteNotice(String id);
  Future<PaginatedResponseModel<PollModel>> getPolls({int page, int size, String? societyId});
  Future<PollModel> getPollById(String id);
  Future<void> votePoll(String pollId, Map<String, dynamic> data);
  Future<PollModel> createPoll(Map<String, dynamic> data);
  Future<PaginatedResponseModel<GroupModel>> getGroups({int page, int size, String? societyId});
  Future<PaginatedResponseModel<MessageModel>> getMessages(String groupId, {int page, int size});
  Future<MessageModel> sendMessage(String groupId, Map<String, dynamic> data);
  Future<PaginatedResponseModel<DocumentModel>> getDocuments({int page, int size, String? societyId});
  Future<DocumentModel> uploadDocument(Map<String, dynamic> data);
}

class CommunicationRemoteDatasourceImpl implements CommunicationRemoteDatasource {
  const CommunicationRemoteDatasourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override Future<PaginatedResponseModel<NoticeModel>> getNotices({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/notices', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => NoticeModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<NoticeModel> getNoticeById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/notices/$id'); return NoticeModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<NoticeModel> createNotice(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/communications/notices', data: data); return NoticeModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> deleteNotice(String id) async => dioClient.delete<void>('/communications/notices/$id');
  @override Future<PaginatedResponseModel<PollModel>> getPolls({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/polls', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => PollModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<PollModel> getPollById(String id) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/polls/$id'); return PollModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> votePoll(String pollId, Map<String, dynamic> data) async => dioClient.post<void>('/communications/polls/$pollId/vote', data: data);
  @override Future<PollModel> createPoll(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/communications/polls', data: data); return PollModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<GroupModel>> getGroups({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/groups', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => GroupModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<PaginatedResponseModel<MessageModel>> getMessages(String groupId, {int page = 0, int size = 20}) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/groups/$groupId/messages', queryParameters: {'page': page, 'size': size}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => MessageModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<MessageModel> sendMessage(String groupId, Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/communications/groups/$groupId/messages', data: data); return MessageModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<DocumentModel>> getDocuments({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/communications/documents', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => DocumentModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<DocumentModel> uploadDocument(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/communications/documents', data: data); return DocumentModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
}

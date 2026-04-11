import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';

abstract class CommunicationRepository {
  // Notices
  Future<Either<Failure, PaginatedResponseModel<NoticeEntity>>> getNotices({int page, int size, String? societyId});
  Future<Either<Failure, NoticeEntity>> getNoticeById(String id);
  Future<Either<Failure, NoticeEntity>> createNotice(Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteNotice(String id);
  // Polls
  Future<Either<Failure, PaginatedResponseModel<PollEntity>>> getPolls({int page, int size, String? societyId});
  Future<Either<Failure, PollEntity>> getPollById(String id);
  Future<Either<Failure, void>> votePoll(String pollId, String option);
  Future<Either<Failure, PollEntity>> createPoll(Map<String, dynamic> data);
  // Groups
  Future<Either<Failure, PaginatedResponseModel<GroupEntity>>> getGroups({int page, int size, String? societyId});
  Future<Either<Failure, PaginatedResponseModel<MessageEntity>>> getMessages(String groupId, {int page, int size});
  Future<Either<Failure, MessageEntity>> sendMessage(String groupId, Map<String, dynamic> data);
  // Documents
  Future<Either<Failure, PaginatedResponseModel<DocumentEntity>>> getDocuments({int page, int size, String? societyId});
  Future<Either<Failure, DocumentEntity>> uploadDocument(Map<String, dynamic> data);
}

import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';

class CreateNoticeUseCase {
  const CreateNoticeUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, NoticeEntity>> call(Map<String, dynamic> data) => repository.createNotice(data);
}

class DeleteNoticeUseCase {
  const DeleteNoticeUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, void>> call(String id) => repository.deleteNotice(id);
}

class CreatePollUseCase {
  const CreatePollUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, PollEntity>> call(Map<String, dynamic> data) => repository.createPoll(data);
}

class GetGroupsUseCase {
  const GetGroupsUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, PaginatedResponseModel<GroupEntity>>> call({int page = 0, int size = 20, String? societyId}) =>
      repository.getGroups(page: page, size: size, societyId: societyId);
}

class GetMessagesUseCase {
  const GetMessagesUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, PaginatedResponseModel<MessageEntity>>> call(String groupId, {int page = 0, int size = 20}) =>
      repository.getMessages(groupId, page: page, size: size);
}

class SendMessageUseCase {
  const SendMessageUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, MessageEntity>> call(String groupId, Map<String, dynamic> data) =>
      repository.sendMessage(groupId, data);
}

class GetDocumentsUseCase {
  const GetDocumentsUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, PaginatedResponseModel<DocumentEntity>>> call({int page = 0, int size = 20, String? societyId}) =>
      repository.getDocuments(page: page, size: size, societyId: societyId);
}

class UploadDocumentUseCase {
  const UploadDocumentUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, DocumentEntity>> call(Map<String, dynamic> data) => repository.uploadDocument(data);
}

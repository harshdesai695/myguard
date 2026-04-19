import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';
import 'package:myguard_frontend/features/helpdesk/domain/repositories/helpdesk_repository.dart';

class AddCommentUseCase {
  const AddCommentUseCase({required this.repository});
  final HelpdeskRepository repository;
  Future<Either<Failure, CommentEntity>> call(String ticketId, Map<String, dynamic> data) =>
      repository.addComment(ticketId, data);
}

class RateTicketUseCase {
  const RateTicketUseCase({required this.repository});
  final HelpdeskRepository repository;
  Future<Either<Failure, TicketEntity>> call(String id, int rating, String? comment) =>
      repository.rateTicket(id, rating, comment);
}

class UpdateTicketStatusUseCase {
  const UpdateTicketStatusUseCase({required this.repository});
  final HelpdeskRepository repository;
  Future<Either<Failure, TicketEntity>> call(String id, String status) =>
      repository.updateTicketStatus(id, status);
}

class GetTicketByIdUseCase {
  const GetTicketByIdUseCase({required this.repository});
  final HelpdeskRepository repository;
  Future<Either<Failure, TicketEntity>> call(String id) => repository.getTicketById(id);
}

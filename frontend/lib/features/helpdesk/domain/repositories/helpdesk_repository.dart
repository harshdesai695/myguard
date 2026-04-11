import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';

abstract class HelpdeskRepository {
  Future<Either<Failure, PaginatedResponseModel<TicketEntity>>> getTickets({int page, int size, String? status});
  Future<Either<Failure, TicketEntity>> getTicketById(String id);
  Future<Either<Failure, TicketEntity>> createTicket(Map<String, dynamic> data);
  Future<Either<Failure, TicketEntity>> updateTicketStatus(String id, String status);
  Future<Either<Failure, CommentEntity>> addComment(String ticketId, Map<String, dynamic> data);
  Future<Either<Failure, TicketEntity>> rateTicket(String id, int rating, String? comment);
}

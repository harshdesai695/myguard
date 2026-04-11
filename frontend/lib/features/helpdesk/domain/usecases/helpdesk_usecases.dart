import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';
import 'package:myguard_frontend/features/helpdesk/domain/repositories/helpdesk_repository.dart';

class GetTicketsUseCase { const GetTicketsUseCase({required this.repository}); final HelpdeskRepository repository; Future<Either<Failure, PaginatedResponseModel<TicketEntity>>> call({int page = 0, int size = 20, String? status}) => repository.getTickets(page: page, size: size, status: status); }
class CreateTicketUseCase { const CreateTicketUseCase({required this.repository}); final HelpdeskRepository repository; Future<Either<Failure, TicketEntity>> call(Map<String, dynamic> data) => repository.createTicket(data); }

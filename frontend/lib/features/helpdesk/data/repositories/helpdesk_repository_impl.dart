import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/helpdesk/data/datasources/helpdesk_remote_datasource.dart';
import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';
import 'package:myguard_frontend/features/helpdesk/domain/repositories/helpdesk_repository.dart';

class HelpdeskRepositoryImpl implements HelpdeskRepository {
  const HelpdeskRepositoryImpl({required this.remoteDatasource});
  final HelpdeskRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }

  @override Future<Either<Failure, PaginatedResponseModel<TicketEntity>>> getTickets({int page = 0, int size = 20, String? status}) async { try { return Right(await remoteDatasource.getTickets(page: page, size: size, status: status)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, TicketEntity>> getTicketById(String id) async { try { return Right(await remoteDatasource.getTicketById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, TicketEntity>> createTicket(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createTicket(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, TicketEntity>> updateTicketStatus(String id, String status) async { try { return Right(await remoteDatasource.updateTicketStatus(id, status)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, CommentEntity>> addComment(String ticketId, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.addComment(ticketId, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, TicketEntity>> rateTicket(String id, int rating, String? comment) async { try { return Right(await remoteDatasource.rateTicket(id, {'rating': rating, if (comment != null) 'comment': comment})); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}

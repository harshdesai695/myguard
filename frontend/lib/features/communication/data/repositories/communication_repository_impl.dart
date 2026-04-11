import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:myguard_frontend/core/error/exceptions.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/communication/data/datasources/communication_remote_datasource.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';

class CommunicationRepositoryImpl implements CommunicationRepository {
  const CommunicationRepositoryImpl({required this.remoteDatasource});
  final CommunicationRemoteDatasource remoteDatasource;
  Failure _m(DioException e) { final er = e.error; if (er is NetworkException) return const NetworkFailure(); if (er is ServerException) return ServerFailure(er.message ?? 'Error'); return const UnknownFailure(); }

  @override Future<Either<Failure, PaginatedResponseModel<NoticeEntity>>> getNotices({int page = 0, int size = 20, String? societyId}) async { try { return Right(await remoteDatasource.getNotices(page: page, size: size, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, NoticeEntity>> getNoticeById(String id) async { try { return Right(await remoteDatasource.getNoticeById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, NoticeEntity>> createNotice(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createNotice(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, void>> deleteNotice(String id) async { try { await remoteDatasource.deleteNotice(id); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<PollEntity>>> getPolls({int page = 0, int size = 20, String? societyId}) async { try { return Right(await remoteDatasource.getPolls(page: page, size: size, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PollEntity>> getPollById(String id) async { try { return Right(await remoteDatasource.getPollById(id)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, void>> votePoll(String pollId, String option) async { try { await remoteDatasource.votePoll(pollId, {'option': option}); return const Right(null); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PollEntity>> createPoll(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.createPoll(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<GroupEntity>>> getGroups({int page = 0, int size = 20, String? societyId}) async { try { return Right(await remoteDatasource.getGroups(page: page, size: size, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<MessageEntity>>> getMessages(String groupId, {int page = 0, int size = 20}) async { try { return Right(await remoteDatasource.getMessages(groupId, page: page, size: size)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, MessageEntity>> sendMessage(String groupId, Map<String, dynamic> data) async { try { return Right(await remoteDatasource.sendMessage(groupId, data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, PaginatedResponseModel<DocumentEntity>>> getDocuments({int page = 0, int size = 20, String? societyId}) async { try { return Right(await remoteDatasource.getDocuments(page: page, size: size, societyId: societyId)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
  @override Future<Either<Failure, DocumentEntity>> uploadDocument(Map<String, dynamic> data) async { try { return Right(await remoteDatasource.uploadDocument(data)); } on DioException catch (e) { return Left(_m(e)); } catch (e) { return Left(UnknownFailure(e.toString())); } }
}

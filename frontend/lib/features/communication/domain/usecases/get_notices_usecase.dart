import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';

class GetNoticesUseCase {
  const GetNoticesUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, PaginatedResponseModel<NoticeEntity>>> call({int page = 0, int size = 20, String? societyId}) =>
      repository.getNotices(page: page, size: size, societyId: societyId);
}

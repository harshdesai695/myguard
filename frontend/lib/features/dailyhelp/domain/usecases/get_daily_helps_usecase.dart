import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/repositories/dailyhelp_repository.dart';

class GetDailyHelpsUseCase {
  const GetDailyHelpsUseCase({required this.repository});
  final DailyHelpRepository repository;
  Future<Either<Failure, PaginatedResponseModel<DailyHelpEntity>>> call({int page = 0, int size = 20}) =>
      repository.getDailyHelps(page: page, size: size);
}

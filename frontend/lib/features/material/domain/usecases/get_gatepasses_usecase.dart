import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart';
import 'package:myguard_frontend/features/material/domain/repositories/material_repository.dart';

class GetGatepassesUseCase { const GetGatepassesUseCase({required this.repository}); final MaterialRepository repository; Future<Either<Failure, PaginatedResponseModel<GatepassEntity>>> call({int page = 0, int size = 20}) => repository.getGatepasses(page: page, size: size); }

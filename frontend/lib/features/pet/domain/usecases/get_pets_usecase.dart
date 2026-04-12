import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart';
import 'package:myguard_frontend/features/pet/domain/repositories/pet_repository.dart';

class GetPetsUseCase { const GetPetsUseCase({required this.repository}); final PetRepository repository; Future<Either<Failure, PaginatedResponseModel<PetEntity>>> call({int page = 0, int size = 20, String? societyId}) => repository.getPets(page: page, size: size, societyId: societyId); }

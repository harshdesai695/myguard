import 'package:dartz/dartz.dart';
import 'package:myguard_frontend/core/error/failures.dart';
import 'package:myguard_frontend/features/communication/domain/repositories/communication_repository.dart';

class VotePollUseCase {
  const VotePollUseCase({required this.repository});
  final CommunicationRepository repository;
  Future<Either<Failure, void>> call(String pollId, String option) =>
      repository.votePoll(pollId, option);
}

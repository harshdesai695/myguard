import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/guard/domain/entities/guard_entity.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/get_checkpoints_usecase.dart';
import 'package:myguard_frontend/features/guard/domain/usecases/log_patrol_usecase.dart';

sealed class PatrolState extends Equatable {
  const PatrolState();
  @override List<Object?> get props => [];
}
class PatrolInitial extends PatrolState { const PatrolInitial(); }
class PatrolLoading extends PatrolState { const PatrolLoading(); }
class CheckpointsLoaded extends PatrolState {
  const CheckpointsLoaded(this.checkpoints);
  final List<CheckpointEntity> checkpoints;
  @override List<Object> get props => [checkpoints];
}
class PatrolLoggedSuccess extends PatrolState {
  const PatrolLoggedSuccess(this.message);
  final String message;
  @override List<Object> get props => [message];
}
class PatrolError extends PatrolState {
  const PatrolError(this.message);
  final String message;
  @override List<Object> get props => [message];
}

class PatrolCubit extends Cubit<PatrolState> {
  PatrolCubit({required GetCheckpointsUseCase getCheckpointsUseCase, required LogPatrolUseCase logPatrolUseCase})
      : _getCheckpointsUseCase = getCheckpointsUseCase, _logPatrolUseCase = logPatrolUseCase, super(const PatrolInitial());

  final GetCheckpointsUseCase _getCheckpointsUseCase;
  final LogPatrolUseCase _logPatrolUseCase;

  Future<void> loadCheckpoints() async {
    emit(const PatrolLoading());
    final result = await _getCheckpointsUseCase();
    result.fold((f) => emit(PatrolError(f.message)), (p) => emit(CheckpointsLoaded(p.content)));
  }

  Future<void> logPatrol({required String checkpointId, String? notes, required String societyId}) async {
    final result = await _logPatrolUseCase(checkpointId: checkpointId, notes: notes, societyId: societyId);
    result.fold((f) => emit(PatrolError(f.message)), (_) => emit(const PatrolLoggedSuccess('Patrol checkpoint scanned')));
  }
}

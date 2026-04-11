import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_polls_usecase.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/vote_poll_usecase.dart';

sealed class PollEvent extends Equatable { const PollEvent(); @override List<Object?> get props => []; }
class PollsFetched extends PollEvent { const PollsFetched({this.page = 0}); final int page; @override List<Object> get props => [page]; }
class PollVoted extends PollEvent { const PollVoted({required this.pollId, required this.option}); final String pollId; final String option; @override List<Object> get props => [pollId, option]; }

sealed class PollState extends Equatable { const PollState(); @override List<Object?> get props => []; }
class PollInitial extends PollState { const PollInitial(); }
class PollLoading extends PollState { const PollLoading(); }
class PollsLoaded extends PollState { const PollsLoaded({required this.polls, required this.hasMore, required this.page}); final List<PollEntity> polls; final bool hasMore; final int page; @override List<Object> get props => [polls, hasMore, page]; }
class PollVoteSuccess extends PollState { const PollVoteSuccess(); }
class PollError extends PollState { const PollError(this.message); final String message; @override List<Object> get props => [message]; }

class PollBloc extends Bloc<PollEvent, PollState> {
  PollBloc({required GetPollsUseCase getPollsUseCase, required VotePollUseCase votePollUseCase}) : _getPollsUseCase = getPollsUseCase, _votePollUseCase = votePollUseCase, super(const PollInitial()) { on<PollsFetched>(_onFetched); on<PollVoted>(_onVoted); }
  final GetPollsUseCase _getPollsUseCase; final VotePollUseCase _votePollUseCase;
  final List<PollEntity> _items = [];

  Future<void> _onFetched(PollsFetched event, Emitter<PollState> emit) async {
    if (event.page == 0) { _items.clear(); emit(const PollLoading()); }
    final result = await _getPollsUseCase(page: event.page);
    result.fold((f) => emit(PollError(f.message)), (p) { _items.addAll(p.content); emit(PollsLoaded(polls: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); });
  }

  Future<void> _onVoted(PollVoted event, Emitter<PollState> emit) async {
    final result = await _votePollUseCase(event.pollId, event.option);
    result.fold((f) => emit(PollError(f.message)), (_) => emit(const PollVoteSuccess()));
  }
}

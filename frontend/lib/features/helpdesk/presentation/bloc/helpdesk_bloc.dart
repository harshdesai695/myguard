import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/helpdesk_usecases.dart';
import 'package:myguard_frontend/features/helpdesk/domain/usecases/helpdesk_admin_usecases.dart';

sealed class HelpdeskEvent extends Equatable { const HelpdeskEvent(); @override List<Object?> get props => []; }
class TicketsFetched extends HelpdeskEvent { const TicketsFetched({this.page = 0, this.status}); final int page; final String? status; @override List<Object?> get props => [page, status]; }
class TicketCreated extends HelpdeskEvent { const TicketCreated(this.data); final Map<String, dynamic> data; @override List<Object> get props => [data]; }
class CommentAdded extends HelpdeskEvent { const CommentAdded({required this.ticketId, required this.data}); final String ticketId; final Map<String, dynamic> data; @override List<Object> get props => [ticketId, data]; }
class TicketRated extends HelpdeskEvent { const TicketRated({required this.ticketId, required this.rating, this.comment}); final String ticketId; final int rating; final String? comment; @override List<Object?> get props => [ticketId, rating, comment]; }
class TicketStatusUpdated extends HelpdeskEvent { const TicketStatusUpdated({required this.ticketId, required this.status}); final String ticketId; final String status; @override List<Object> get props => [ticketId, status]; }

sealed class HelpdeskState extends Equatable { const HelpdeskState(); @override List<Object?> get props => []; }
class HelpdeskInitial extends HelpdeskState { const HelpdeskInitial(); }
class HelpdeskLoading extends HelpdeskState { const HelpdeskLoading(); }
class TicketsLoaded extends HelpdeskState { const TicketsLoaded({required this.tickets, required this.hasMore, required this.page}); final List<TicketEntity> tickets; final bool hasMore; final int page; @override List<Object> get props => [tickets, hasMore, page]; }
class HelpdeskActionSuccess extends HelpdeskState { const HelpdeskActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class HelpdeskError extends HelpdeskState { const HelpdeskError(this.message); final String message; @override List<Object> get props => [message]; }

class HelpdeskBloc extends Bloc<HelpdeskEvent, HelpdeskState> {
  HelpdeskBloc({
    required GetTicketsUseCase getTicketsUseCase,
    required CreateTicketUseCase createTicketUseCase,
    required AddCommentUseCase addCommentUseCase,
    required RateTicketUseCase rateTicketUseCase,
    required UpdateTicketStatusUseCase updateTicketStatusUseCase,
  }) : _getTicketsUseCase = getTicketsUseCase,
       _createTicketUseCase = createTicketUseCase,
       _addCommentUseCase = addCommentUseCase,
       _rateTicketUseCase = rateTicketUseCase,
       _updateTicketStatusUseCase = updateTicketStatusUseCase,
       super(const HelpdeskInitial()) {
    on<TicketsFetched>(_onFetched);
    on<TicketCreated>(_onCreated);
    on<CommentAdded>(_onCommentAdded);
    on<TicketRated>(_onRated);
    on<TicketStatusUpdated>(_onStatusUpdated);
  }
  final GetTicketsUseCase _getTicketsUseCase;
  final CreateTicketUseCase _createTicketUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final RateTicketUseCase _rateTicketUseCase;
  final UpdateTicketStatusUseCase _updateTicketStatusUseCase;
  final List<TicketEntity> _items = [];

  Future<void> _onFetched(TicketsFetched e, Emitter<HelpdeskState> emit) async { if (e.page == 0) { _items.clear(); emit(const HelpdeskLoading()); } final r = await _getTicketsUseCase(page: e.page, status: e.status); r.fold((f) => emit(HelpdeskError(f.message)), (p) { _items.addAll(p.content); emit(TicketsLoaded(tickets: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); }); }

  Future<void> _onCreated(TicketCreated e, Emitter<HelpdeskState> emit) async { emit(const HelpdeskLoading()); final r = await _createTicketUseCase(e.data); r.fold((f) => emit(HelpdeskError(f.message)), (_) => emit(const HelpdeskActionSuccess('Ticket created'))); }

  Future<void> _onCommentAdded(CommentAdded e, Emitter<HelpdeskState> emit) async { final r = await _addCommentUseCase(e.ticketId, e.data); r.fold((f) => emit(HelpdeskError(f.message)), (_) => emit(const HelpdeskActionSuccess('Comment added'))); }

  Future<void> _onRated(TicketRated e, Emitter<HelpdeskState> emit) async { final r = await _rateTicketUseCase(e.ticketId, e.rating, e.comment); r.fold((f) => emit(HelpdeskError(f.message)), (_) => emit(const HelpdeskActionSuccess('Ticket rated'))); }

  Future<void> _onStatusUpdated(TicketStatusUpdated e, Emitter<HelpdeskState> emit) async { final r = await _updateTicketStatusUseCase(e.ticketId, e.status); r.fold((f) => emit(HelpdeskError(f.message)), (_) => emit(const HelpdeskActionSuccess('Status updated'))); }
}
